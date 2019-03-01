# Local development

## Setup

1. Clone repo to the same level as your projects `git clone git@github.com:alessod/og-setup.git og_dev`

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
    │   ├── og_dev  <------------------- HERE
    │   ├── ordergroove_nucleus
    │   ├── relay
    │   ├── whiskey
    │   └── woodhouse
    ```

2. Create config file `.env.container.cfg` inside each project

3. Create .env file inside this repo

    ```bash
    DEV_PATH=./og_dev
    CONFIG_FILE=.env.container.cfg
    LOG_MAX_SIZE=50k
    LOG_MAX_FILE=2
    ```

4. Export ssh key for pulling private python repos

    `export SSH_PRIV_KEY=$(cat ~/.ssh/id_rsa | base64)`

5. Launch apps

    `docker-compose up -d`

    Note: On the first run, docker will have to build each image for the first time. This may take some time.

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

    ```python
    import ptvsd
    ptvsd.enable_attach(address=('0.0.0.0', 3000))
    ```
