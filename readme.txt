# Anti-Scam Tool
> Herramienta automatizada para llenar webhooks de datos basura con dominio @comunidad.unam.mx
> Usa Tor vía proxychains para anonimizar las peticiones.

## Uso local

### Instalar dependencias

**Debian / Ubuntu / Kali**
```bash
sudo apt update && sudo apt install -y \
    curl jq proxychains4 tor coreutils
```

**Arch Linux**
```bash
sudo pacman -Sy --needed \
    curl jq proxychains-ng tor coreutils

### Arch Linux

```bash
sudo pacman -Sy --needed \
    bash \
    curl \
    jq \
    proxychains-ng \
    tor \
    coreutils \
    grep \
    sed
```

---

### Configurar Tor
```bash
sudo systemctl start tor
```

Edita `/etc/proxychains4.conf` y asegúrate de tener:
dynamic_chain
socks5 127.0.0.1 9050


---

## Diccionarios requeridos

Descarga y coloca en la raíz del proyecto:

- [rockyou.txt](https://github.com/zacheller/rockyou)
- [xato-net-10-million-usernames.txt](https://github.com/danielmiessler/SecLists/blob/master/Usernames/xato-net-10-million-usernames.txt)

### Ejecutar
```bash
chmod +x antiscam.sh && ./antiscam.sh
```

---

## Docker

```bash
docker build -t anti-scam .
docker run --rm anti-scam
```
## ¿Cómo funciona?

1. Verifica que el webhook objetivo esté activo
2. Anonimiza la conexión vía Tor
3. Envía peticiones para saturar un webhook con información falsa para dificultar el robo de cuentas auténticas

