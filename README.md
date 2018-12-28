# Local development

## Create .env file

```bash
DEV_PATH=./local_dev
CONFIG_FILE=.env.container.cfg
LOG_MAX_SIZE=50k
LOG_MAX_FILE=2
```

## For lego make sure export environment variable

`set -x SSH_PRIV_KEY (cat ~/.ssh/id_rsa | base64)`

## Port mapping for apps

whiskey: 7000
lego: 7001
moonshine-api: 8000
chrono: 8001
abtesting-service: 8002

## Config files

For config files to work both in the container and on your machine add the line below to your `/etc/hosts` file.

```bash
127.0.0.1 localhost abtesting-service chrono moonshine-api lego whiskey mariadb memcached mongo rabbitmq redis
```
