# serverr
Docker media and home server stack with Docker Compose, Traefik, Google OAuth2, and LetsEncrypt

Setup Tips:
1. Insall Docker
    1. Set privileges on folder and sub-folders:
        1. `sudo setfacl -Rdm g:docker:rwx serverr`
        1. `sudo chmod -R 775 serverr`
1. Make sure to have domain/DNS up to date, and API access to provider (whitelist your IP if needed)
1. Update router settings:
    1. Make machine static internal IP
    1. Port forward 80, 443 (Traefik) and 32400 (Plex)
1. `cp serverr/.env.template serverr/.env` and fill out variables
1. Setup Traefik2 files:
    1. `touch serverr/app-data/traefik2/acme/acme.json`
    1. `chmod 600 serverr/app-data/traefik2/acme/acme.json`
    1. `touch serverr/app-data/traefik2/traefik.log`
1. Setup docker secrets:
    1. `mkdir serverr/secrets`
    1. `sudo chown root:root serverr/secerts`
    1. `sudo chmod 600 serverr/secrets`
    1. [Domain Name Providers](https://docs.traefik.io/https/acme/#providers) (I use Namecheap, `docker-compose.yml` will need to be updated if provider changes)
1. Set up Google Cloud Platform oauth/credentials
1. SSL certs:
    1. Uncomment traefik sections
    1. `docker-compose up -d traefik` and check certs at `traefik.domain.com` and/or `acme.json`
    1. Comment staging, clear out `acme.json`
    1. Bring up traefik again and check certs at `traefik.domain.com` and/or `acme.json`
    1. Comment out certresolver label and bring up traefik last time
1. Configure various containers via their subdomain.domain.com addresses, things to note:
    1. Sabnzbd 
        1. Have to access Sabnzbd via IP:Port/sabnzbd before whitelisting the subdomain in config
    1. Tauttulli
        1. If using the official remote app, disable oauth, register device token, update .env, re-enable oauth.
1. Install UFW:
    1. Allow 80, 443, 32400 from anywhere
    1. Allow 22 from 192.168.0.0/16
1. Change DOCKER_OPTS to Respect IP Table Firewall
    1. `sudo vi /etc/default/docker`
    1. add `DOCKER_OPTS="--iptables=false"`
1. Install snapraid, gitclone snapraid-runner and update conf, install and configure mergerFs, install rclone and configure to Dropbox
1. Update scripts/crontab.template and copy to `sudo crontab -e`
1. [CrowdSec Setup Guide](https://www.smarthomebeginner.com/crowdsec-docker-compose-1-fw-bouncer/)
