#!/usr/bin/env ash

docker run -d \
    --device=/dev/ttyUSB0:/dev/ttyUSB0 \
    --group-add dialout \
    --name zigbee2mqtt \
    --restart=unless-stopped \
    -e TZ=America/Sao_Paulo \
    -e Z2M_WATCHDOG=default \
    -p 8080:8080 \
    -v "$HOME/.z2m:/app/data" \
    -v /run/udev:/run/udev:ro \
    ghcr.io/koenkk/zigbee2mqtt

echo "Has already started. Logs will be displayed, but you can safely exit."

docker logs -n 1000 -f zigbee2mqtt
