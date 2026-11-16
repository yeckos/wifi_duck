# Wifi_Duck
### Yeckos El Pato Maligno

Escanea TU red, ve quien esta conectado y bloquea al intruso en TU propia red.

> Solo usalo en TU propia red.

## Descargar con git clone

```bash
git clone https://github.com/yeckos/Wifi_Duck.git
cd Wifi_Duck
chmod +x wifi_duck.sh
./wifi_duck.sh
```



## Menu

```
Yeckos El Pato Maligno
---------------------------

+-----------------------------------------------+
|  BIENVENIDO A Wifi_Duck v2.1.0                |
|  1 = Escanear tu red                          |
|  2 = Ver quien esta conectado                 |
|  3 = Bloquear al intruso en TU red            |
+-----------------------------------------------+

Solo usalo en TU propia red.
```

## Como bloquear

Metodo legal en tu propia red:
- Filtrado MAC / control parental de tu router (recomendado)
- Lista de bloqueados guardada en el script
- `iptables` solo si esta computadora es el gateway

No usa deauth ni ARP spoofing.

## Requisitos

- Linux / macOS / Termux
- `bash`, `ping`, `arp` o `ip`

## Archivos

```
Wifi_Duck/
├── wifi_duck.sh   # programa
├── README.md      # esto
└── .gitignore
```
