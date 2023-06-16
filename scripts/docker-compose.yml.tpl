version: '3.8'

services:
  api:
    image: ${ecr_address}/z42-api:latest
    restart: on-failure
    ports:
      - "3000:3000"
    volumes:
      - ./configs/api-config.json:/etc/z42/api-config.json
      - ./templates:/var/z42/templates
      - ./logs/api:/var/log/api
    networks:
      - app-network

  resolver:
    image: ${ecr_address}/z42-resolver:latest
    restart: on-failure
    ports:
      - "10.0.100.228:53:1053/tcp"
      - "10.0.100.228:53:1053/udp"
    volumes:
      - ./configs/resolver-config.json:/etc/z42/resolver-config.json
      - ./assets/geoCity.mmdb:/var/z42/geoCity.mmdb
      - ./assets/geoIsp.mmdb:/var/z42/geoIsp.mmdb
      - ./logs/resolver:/var/log/resolver
    networks:
      - app-network

  updater:
    image: ${ecr_address}/z42-updater:latest
    restart: on-failure
    volumes:
      - ./configs/updater-config.json:/etc/z42/updater-config.json
      - ./logs/updater:/var/log/updater
    networks:
      - app-network

  webui:
    image: ${ecr_address}/z42-webui:latest
    restart: on-failure
    environment:
      HOST: '0.0.0.0'
      NUXT_ENV_API_BASE_URL: 'https://zone-42.com/api'
      NUXT_ENV_RECAPTCHA_SITE_KEY: '${recaptcha_key}'
    ports:
      - "8000:8000"
    networks:
      - app-network

  nginx:
    image: nginx:latest
    restart: on-failure
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./configs/nginx.conf:/etc/nginx/nginx.conf
      - ./certs:/etc/ssl/zone-42.com
      - ./logs/nginx:/var/log/nginx
    networks:
      - app-network


networks:
  app-network:
    driver: bridge
