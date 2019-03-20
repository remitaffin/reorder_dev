# Local development

## Setup

1. Clone repo to the same level as your projects `git clone git@github.com:alessod/reorder_dev.git reorder_dev`

    ```bash
    ├── Develop
    │   ├── abtesting
    │   ├── abtesting-service
    │   ├── chronotrigger
    │   ├── memento
    │   ├── moonshine-api
    │   ├── moonshine-api-lite
    │   ├── moonshine-celery
    │   ├── moonshine-core
    │   ├── reorder_dev  <------------------- HERE
    │   ├── relay
    │   ├── relay-models
    │   └── woodhouse
    ```

2. Create file `.env.container.cfg` inside each project for their configuration

    For each app and service use the following [urls](#apps-and-services-urls).

3. Copy .env.default file inside this repo

    `cp .env.default .env`

4. Export ssh key for pulling private python repos

    `export SSH_PRIV_KEY=$(cat ~/.ssh/id_rsa | base64)`

5. `ln -s $PWD/.dockerignore $(dirname $PWD)/.dockerignore`

6. `docker-compose build --parallel`

7. Run `setup.sh`

8. Launch apps

    `docker-compose up -d`

## Apps and services URLs

```bash
http://moonshine-api:8000
# moonshine-api-client-id
# moonshine-api-secret

http://chrono:8001
# chrono-client-id
# chrono-secret

http://abtesting-service:8002
# abtesting-service-client-id
# abtesting-service-secret

http://rabbitmq:15672  # rabbitmq management UI
amqp://rabbitmq:rabbitmq@rabbitmq:5672

memcached:11211
mongodb://mongo:27017
mysql://root:ogpassw@mariadb:3306
redis://redis:6379
```

## Config files

For config files to work both in the container and on your machine add the line below to your `/etc/hosts` file.

```bash
127.0.0.1 localhost abtesting-service chrono moonshine-api mariadb memcached mongo rabbitmq redis
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
