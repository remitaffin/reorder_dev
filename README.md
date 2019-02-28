# Local development

## Clone repo

Clone repo to the same level as your projects `git clone git@github.com:alessod/og-setup.git og_dev`

```bash
├── Develop
│   ├── abtesting
│   ├── abtesting-service
│   ├── call-me-maybe
│   ├── chronotrigger
│   ├── memento
│   ├── moonshine-api
│   ├── moonshine-api-lite
│   ├── moonshine-celery
│   ├── moonshine-core
│   ├── moonshine-relay
│   ├── og_dev  <------------------- HERE
│   ├── ordergroove_nucleus
│   ├── whiskey
│   └── woodhouse
```

## Create .env file

```bash
DEV_PATH=./og_dev
CONFIG_FILE=.env.container.cfg
LOG_MAX_SIZE=50k
LOG_MAX_FILE=2
```

## Export ssh key for pulling private python repos

`export SSH_PRIV_KEY=$(cat ~/.ssh/id_rsa | base64)`

## Port mapping for apps

```bash
whiskey: 7000
lego: 7001
moonshine-api: 8000
chrono: 8001
abtesting-service: 8002
```

## Add indexes to mongoDB

```javascript
db.getCollection('one-time-tasks').createIndex({"created": 1})
db.getCollection('one-time-tasks').createIndex({"name": 1}, { unique: true })
db.getCollection('one-time-tasks').createIndex({"run_at": 1}, { expireAfterSeconds: 7776000 })
db.getCollection('one-time-tasks').createIndex({"status": 1, "run_at": 1})
```

## Config files

For config files to work both in the container and on your machine add the line below to your `/etc/hosts` file.

```bash
127.0.0.1 localhost abtesting-service chrono moonshine-api lego whiskey mariadb memcached mongo rabbitmq redis
```

## For debugging container

In local environment install ptvsd `pip install ptvsd`

1. Change command to: `python manage.py runserver --noreload --nothreading 0.0.0.0:8000`

2. Export port `'3000:3000'`

3. Update `manage.py`

```
import ptvsd
ptvsd.enable_attach(address=('0.0.0.0', 3000))
```
