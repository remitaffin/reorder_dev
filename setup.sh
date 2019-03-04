#! /bin/bash

#
# Setup Django apps
#

mysql -h 127.0.0.1 -u root -pogpassw -e "create database abtesting";
mysql -h 127.0.0.1 -u root -pogpassw -e "create database chrono";
mysql -h 127.0.0.1 -u root -pogpassw -e "create database moonshine";
# mysql -h 127.0.0.1 -u root -pogpassw -e "create database callmemaybe"; NOT SETUP YET

docker-compose exec abtesting-service ./manage.py migrate
docker-compose exec chrono ./manage.py migrate
docker-compose exec moonshine-api ./manage.py migrate

docker-compose exec abtesting-service bash -c 'echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('"'admin'"', '"'admin@example.com'"', '"'pass'"')" | python manage.py shell'
docker-compose exec chrono bash -c 'echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('"'admin'"', '"'admin@example.com'"', '"'pass'"')" | python manage.py shell'
docker-compose exec moonshine-api bash -c 'echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('"'admin'"', '"'admin@example.com'"', '"'pass'"')" | python manage.py shell'

#
# Moonshine-api
#

docker-compose exec moonshine-api bash -c 'export PYTHONPATH=/usr/src/app && python feed/import_all.py env=dev'

#
# Whiskey/Lego
#

mysql -h 127.0.0.1 -u root -pogpassw -e "create database ordergroove";
# Use stg DB
# https://ordergroove.atlassian.net/wiki/spaces/DEV/pages/48267266/Backend+environment+set-up
