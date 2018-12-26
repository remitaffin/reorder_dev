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


## Port mapping for other services

Memcached, Mongo, RabbitMQ and Redis are mapped to different ports on your
machine vs inside the containers. Inside the containers they use the
default ports but on your machine they use the default port plus 1
i.e. mongo defaults to port `27017`, add 1 and it is `27018`, the full url
is `127.0.0.1:27018`.
