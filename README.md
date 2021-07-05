# htpc
Docker media server stack with Docker Compose, Traefik 2, Google OAuth2, and LetsEncrypt

Setup:
1. Insall Docker and Docker Compose
1. Set privileges on folder and sub-folders:
    1. `sudo setfacl -Rdm g:docker:rwx ~/htpc`
    1. `sudo chmod -R 775 ~/htpc`
1. Make sure to have domain/DNS up to date, and API access to provider
1. Update router settings:
    1. Make machine static internal IP
    1. Port forward 80, 443 (Traefik) and 32400 (Plex)
1. `mv .env.template .env` and fill out variables
1. If you have dynamic IP, setup cronjob to update your provider periodically:
    1. `0 3 * * * curl "http://dynamicdns.park-your-domain.com/update?host=<HOST>&domain=<DOMAIN>&password=<PASSWORD>" > <LOG_DIR>/dynamicdns.log 2>&1`
1. Setup Traefik2 files:
    1. `touch ~/htpc/traefik2/acme/acme.json`
    1. `chmod 600 ~/htpc/traefik2/acme/acme.json`
    1. `touch ~/htpc/traefik2/traefik.log`
1. Setup docker secrets:
    1. `mkdir ~/htpc/secrets`
    1. `sudo chown root:root ~/htpc/secerts`
    1. `sudo chmod 600 ~/htpc/secrets`
    1. [Domain Name Providers](https://docs.traefik.io/https/acme/#providers) (I use Namecheap, `docker-compose.yml` will need to be updated if provider changes)
1. Set up Google Cloud Platform oauth/credentials
1. SSL certs:
    1. Uncomment traefik sections
    1. `docker-compose up -d traefik` and check certs at `traefik.domain.com` and/or `acme.json`
    1. Comment staging, clear out `acme.json`
    1. Bring up traefik again and check certs at `traefik.domain.com` and/or `acme.json`
    1. Comment out certresolver label and bring up traefik again
1. Configure various containers via their subdomain.domain.com addresses
    1. Jackett to setup indexers
    1. Hydra (setup usenet provider and indexer accounts first)
        1. Import Jackett indexers
    1. Sabnzbd (have to access Sabnzbd via IP:Port/sabnzbd before whitelisting the subdomain in config)
    1. Deluge
    1. Sonarr/Radarr/Lidarr/Bazarr using Hydra, Sabnzbd, Deluge, and media locations
        1. Use Hydra to export individual indexers to the *arrs.
    1. Plex to read from media locations
    1. Overseerr with Sonarr/Radarr/Plex
    1. Tautulli with Plex
    1. Heimdall to access it all from one easy domain
1. Install UFW:
    1. Allow 80, 443, 32400 from anywhere
    1. Allow 22 from 192.168.0.0/16
1. Change DOCKER_OPTS to Respect IP Table Firewall
    1. `sudo vi /etc/default/docker`
    1. add `DOCKER_OPTS="--iptables=false"`
1. Install rclone and configure
    1. Copy down Cloud data
    1. Setup sync `0 3 * * * rclone sync <MEDIA_DIR>/music/ Dropbox:Music --log-level=NOTICE --log-file=<LOG_DIR>/rclone.log`
1. Setup MariaDB and Guacamole
    1. Copy initialization script `sudo docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql > mariadb/guac_initdb.sql`
    1. Enter mariadb container, login as root, create the guac db, user/password, and set privileges
    1. In mariadb container, run guac initialization script `cat /config/guac_initdb.sql | mysql -u <guac_user> -p <guac_db>;`
    1. Login to guac as guacadmin, setup new admin, delete old admin. Configure connections.

