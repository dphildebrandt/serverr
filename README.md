# htpc
Docker media server stack with Docker Compose, Traefik 2, Google OAuth2, and LetsEncrypt

Setup:
1. Insall Docker and Docker Compose
1. Set privileges on folder and sub-folders `sudo setfacl -Rdm g:docker:rwx ~/htpc`, `sudo chmod -R 775 ~/htpc`
1. Make sure to have domain/DNS up to date, and API access to provider
1. `mv .env.template .env` and fill out variables
1. `touch traefik2/acme/acme.json` and `chmod 600 traefik2/acme/acme.json`
1. If dynamic IP: `crontab -e` add `0 0 * * * curl "http://dynamicdns.park-your-domain.com/update?host=<HOST>&domain=<DOMAIN>&password=<DDNS_PASSWORD>"`
1. `docker network create t2_proxy` and `docker network socket_proxy`
1. Settle up Google Cloud Platform oauth/credentials
1. SSL certs:
    1. Uncomment traefik sections
    1. `docker-compose up -d traefik` and check certs at `traefik.domain.com` and/or `acme.json`
    1. Comment staging, clear out `acme.json`
    1. bring up traefik again and check certs at `traefik.domain.com` and/or `acme.json`
    1. Comment out certresolver label and bring up traefik again
1. Configure various containers via their subdomain.domain.com addresses
    1. Deluge and Sabnzbd (have to access Sabnzbd via IP:Port/sabnzbd before whitelisting the subdomain in config)
    1. Jackett/Hydra (setup usenet provider and indexer accounts first)
    1. Sonarr/Radarr using indexers, downloaders, and media locations
    1. Plex to read from media locations
    1. Ombi with Sonarr/Radarr/Plex
    1. Portainer (follow comment about socket-proxy in `docker-compose.yml`)
    1. Organizr to acces it all
