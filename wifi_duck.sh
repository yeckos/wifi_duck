#!/bin/bash
# Wifi_Duck v2.1.0 - Yeckos El Pato Maligno
# Solo usalo en TU propia red.
VERSION="2.1.0"
GREEN="\033[0;32m"; YELLOW="\033[1;33m"; CYAN="\033[0;36m"; PURPLE="\033[0;35m"; NC="\033[0m"
BLOCKLIST="$HOME/.wifi_duck_blocklist.txt"
touch "$BLOCKLIST" 2>/dev/null || BLOCKLIST="/tmp/.wifi_duck_blocklist.txt"

mostrar_pato() {
clear
echo ""
echo -e "${YELLOW}  Yeckos  El  Pato  Maligno${NC}"
echo -e "${CYAN}  ---------------------------${NC}"
echo ""
echo -e "${GREEN}   +-----------------------------------------------+${NC}"
echo -e "${GREEN}   |  BIENVENIDO A Wifi_Duck v$VERSION                  |${NC}"
echo -e "${GREEN}   |  1 = Escanear tu red                            |${NC}"
echo -e "${GREEN}   |  2 = Ver quien esta conectado                   |${NC}"
echo -e "${GREEN}   |  3 = Bloquear al intruso en TU red              |${NC}"
echo -e "${GREEN}   +-----------------------------------------------+${NC}"
echo ""
echo -e "${PURPLE}   Solo usalo en TU propia red.${NC}"
echo ""
}

mi_red() {
  # Detecta la red local, ej: 192.168.1.0/24
  IP=$(ip route get 1.1.1.1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="src") print $(i+1)}')
  [ -z "$IP" ] && IP=$(hostname -I 2>/dev/null | awk '{print $1}')
  PREFIJO=$(echo "$IP" | cut -d. -f1-3)
  echo "$PREFIJO"
}

escanear() {
  PREFIJO=$(mi_red)
  [ -z "$PREFIJO" ] && { echo "No pude detectar tu red."; return; }
  echo "Escaneando $PREFIJO.1 - $PREFIJO.254 ..."
  for i in $(seq 1 254); do
    (ping -c 1 -W 1 "$PREFIJO.$i" >/dev/null 2>&1 &)
  done
  wait
  echo ""
  echo "IP              MAC                 NOMBRE / MARCA"
  echo "-------------------------------------------------"
  arp -a 2>/dev/null | sed 's/[()]//g' | awk '{print $2"  "$4"  "$1}' | sort -u
  # Alternativa si no hay arp
  if ! command -v arp >/dev/null 2>&1; then
    ip neigh 2>/dev/null | awk '{print $1"  "$5"  "$3}'
  fi
  echo ""
  echo "Bloqueados guardados:"
  cat "$BLOCKLIST" 2>/dev/null || echo "(ninguno)"
}

bloquear() {
  escanear
  echo ""
  read -p "Escribe la IP o MAC del intruso a bloquear: " OBJETIVO
  [ -z "$OBJETIVO" ] && { echo "No escribiste nada."; return; }
  if grep -q "$OBJETIVO" "$BLOCKLIST" 2>/dev/null; then
    echo "Ya estaba en tu lista de bloqueados."
  else
    echo "$OBJETIVO" >> "$BLOCKLIST"
    echo "Guardado en tu lista de bloqueados."
  fi
  echo ""
  echo "Para que quede bloqueado de verdad, haz esto en TU router:"
  echo "1. Entra a tu router (ej: 192.168.1.1)"
  echo "2. Busca: Filtrado MAC / MAC Filtering / Control parental"
  echo "3. Agrega la MAC del intruso y ponla en DENEGAR / BLOCK"
  echo "4. Guarda y reinicia el router si te lo pide"
  echo ""
  echo "Metodo avanzado - solo si ESTA computadora es el gateway:"
  echo "  sudo iptables -A FORWARD -s $OBJETIVO -j DROP"
  echo "  sudo iptables -A INPUT -s $OBJETIVO -j DROP"
}

while true; do
  mostrar_pato
  read -p "Elige 1, 2, 3 o 0 para salir: " OPCION
  case "$OPCION" in
    1) escanear ;;
    2) escanear ;;
    3) bloquear ;;
    0) echo "Hasta luego."; exit 0 ;;
    *) echo "Opcion no valida." ;;
  esac
  echo ""
  read -p "Enter para volver al menu..." _
done
