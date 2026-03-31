FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
        curl ca-certificates lib32gcc-s1 \
        libglib2.0-0 libnss3 libatk1.0-0 libatk-bridge2.0-0 \
        libcups2 libdrm2 libxkbcommon0 libxcomposite1 \
        libxdamage1 libxfixes3 libxrandr2 libgbm1 \
        libasound2 libpango-1.0-0 libcairo2 libx11-6 libxext6 \
        libgtk-3-0 libgdk-pixbuf2.0-0 xvfb \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash steam && \
    mkdir -p /home/steam/steamcmd /home/steam/data/server /home/steam/data/saves /home/steam/data/steamcache && \
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxf - -C /home/steam/steamcmd && \
    ln -s /home/steam/data/server /home/steam/wayward-server && \
    ln -s /home/steam/data/saves /home/steam/save && \
    ln -s /home/steam/data/steamcache /home/steam/Steam && \
    chown -R steam:steam /home/steam

USER steam
WORKDIR /home/steam

COPY --chown=steam:steam entrypoint.sh /home/steam/entrypoint.sh
RUN chmod +x /home/steam/entrypoint.sh

EXPOSE 38740/udp

ENTRYPOINT ["/home/steam/entrypoint.sh"]
