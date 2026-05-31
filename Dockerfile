FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    bash \
    curl \
    jq \
    proxychains4 \
    tor \
    coreutils \
    && rm -rf /var/lib/apt/lists/*

# Configurar proxychains
RUN sed -i 's/^strict_chain/dynamic_chain/' /etc/proxychains4.conf && \
    sed -i '/^socks4/d' /etc/proxychains4.conf && \
    echo "socks5 127.0.0.1 9050" >> /etc/proxychains4.conf

# Configurar Tor
RUN echo "ControlPort 9051" >> /etc/tor/torrc

WORKDIR /app
COPY . .
RUN chmod +x antiscam.sh

CMD ["bash", "-c", "service tor start && ./antiscam.sh"]
