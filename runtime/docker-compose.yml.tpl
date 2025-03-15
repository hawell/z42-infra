version: '3.8'

services:

  auth-api:
    image: ${ecr_address}/auth-api:latest
    restart: on-failure
    ports:
      - "3002:3002"
    volumes:
      - ./auth/configs/auth-config.json:/etc/cs/auth-config.json
      - ./auth/templates:/var/cs/templates
      - ./auth/logs/api:/var/log/api
    networks:
      - app-network

  z42-api:
    image: ${ecr_address}/z42-api:latest
    restart: on-failure
    ports:
      - "3000:3000"
    volumes:
      - ./z42/configs/api-config.json:/etc/z42/api-config.json
      - ./z42/templates:/var/z42/templates
      - ./z42/logs/api:/var/log/api
    networks:
      - app-network

  z42-resolver:
    image: ${ecr_address}/z42-resolver:latest
    restart: on-failure
    ports:
      - "10.0.100.91:53:1053/tcp"
      - "10.0.100.91:53:1053/udp"
    volumes:
      - ./z42/configs/resolver-config.json:/etc/z42/resolver-config.json
      - ./z42/assets/geoCity.mmdb:/var/z42/geoCity.mmdb
      - ./z42/assets/geoIsp.mmdb:/var/z42/geoIsp.mmdb
      - ./z42/logs/resolver:/var/log/resolver
    networks:
      - app-network

  z42-updater:
    image: ${ecr_address}/z42-updater:latest
    restart: on-failure
    volumes:
      - ./z42/configs/updater-config.json:/etc/z42/updater-config.json
      - ./z42/logs/updater:/var/log/updater
    networks:
      - app-network

  z42-webui:
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

  lighthouse-api:
    image: ${ecr_address}/lh-api:latest
    restart: on-failure
    env_file:
      - ./lighthouse/.env.api
    ports:
      - "3001:3001"
    networks:
      - app-network

  lighthouse-importer:
    image: ${ecr_address}/lh-importer:latest
    restart: on-failure
    env_file:
      - ./lighthouse/.env.importer
    networks:
      - app-network

  lighthouse-webui:
    image: ${ecr_address}/lh-webui:latest
    restart: on-failure
    env_file:
      - ./lighthouse/.env.webui
    ports:
      - "8001:8001"
    networks:
      - app-network

  watchlist-api:
    image: ${ecr_address}/watchlist-api:latest
    restart: on-failure
    env_file:
      - ./watchlist/.env.api
    ports:
      - "3003:3003"
    networks:
      - app-network

  watchlist-importer:
    image: ${ecr_address}/watchlist-importer:latest
    restart: on-failure
    env_file:
      - ./watchlist/.env.imorter
    networks:
      - app-network
    volumes:
      - ./watchlist/privacy-policy.html:/assets/privacy-policy.html


  nginx:
    image: nginx:latest
    restart: on-failure
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./certs/zone-42.com:/etc/ssl/zone-42.com
      - ./certs/chordsoft.org:/etc/ssl/chordsoft.org
      - ./logs/nginx:/var/log/nginx
      - ./app-ads.txt:/var/www/app-ads.txt
    networks:
      - app-network


networks:
  app-network:
    driver: bridge
