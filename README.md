# htpc
Docker media server stack with Docker Compose, Traefik 2, Google OAuth2, and LetsEncrypt

Setup:
1. Insall Docker and Docker Compose
1. Set privileges on folder and sub-folders:
    1. `sudo setfacl -Rdm g:docker:rwx ~/htpc`
    1. `sudo chmod -R 775 ~/htpc`
1. Make sure to have domain/DNS up to date, and API access to provider
1. `mv .env.template .env` and fill out variables           
1. If you have dynamic IP, setup cronjob to update your provider periodically: 
    1. `crontab -e` 
    1. `0 0 * * * curl "http://dynamicdns.park-your-domain.com/update?host=<HOST>&domain=<DOMAIN>&password=<DDNS_PASSWORD>"`
1. Setup Traefik2 files:
    1. `touch ~/htpc/traefik2/acme/acme.json` 
    1. `chmod 600 ~/htpc/traefik2/acme/acme.json`
    1. `touch ~/htpc/traefik2/traefik.log`
1. Create docker networks:
    1. `docker network create t2_proxy`
    1. `docker network create socket_proxy`
1. Setup docker secrets:
    1. `mkdir ~/htpc/secrets`
    1. `sudo chown root:root ~/htpc/secerts`
    1. `sudo chmod 600 ~/htpc/secrets`
    1. [Domain Name Providers](https://docs.traefik.io/https/acme/#providers)
        1. I use Namecheap, `docker-compose.yml` will need to be updated if provider changes
1. Set up Google Cloud Platform oauth/credentials
1. SSL certs:
    1. Uncomment traefik sections
    1. `docker-compose up -d traefik` and check certs at `traefik.domain.com` and/or `acme.json`
    1. Comment staging, clear out `acme.json`
    1. Bring up traefik again and check certs at `traefik.domain.com` and/or `acme.json`
    1. Comment out certresolver label and bring up traefik again
1. Configure various containers via their subdomain.domain.com addresses
    1. Sabnzbd (have to access Sabnzbd via IP:Port/sabnzbd before whitelisting the subdomain in config)
    1. Hydra (setup usenet provider and indexer accounts first)
    1. Sonarr/Radarr using Hydra, Jackett, Sabnzbd, Deluge, and media locations
    1. Plex to read from media locations
    1. Ombi with Sonarr/Radarr/Plex
    1. Portainer (follow comment about socket-proxy in `docker-compose.yml`)
    1. Tautulli with Plex
    1. Organizr to access it all from one easy domain
1. Install UFW:
    1. Allow 80, 443 anywhere
    1. Allow 22 192.168.0.0/16
1. Change DOCKER_OPTS to Respect IP Table Firewall
    1. `sudo vi /etc/default/docker`
    1. add `DOCKER_OPTS="--iptables=false"`
