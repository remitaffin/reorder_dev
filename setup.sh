#! /bin/bash

#
# Setup Django apps
#

mysql -h 127.0.0.1 -u root -pogpassw -e "create database abtesting-service";
mysql -h 127.0.0.1 -u root -pogpassw -e "create database chrono";
mysql -h 127.0.0.1 -u root -pogpassw -e "create database moonshine";

docker-compose exec abtesting-service ./manage.py migrate
docker-compose exec chrono ./manage.py migrate
docker-compose exec moonshine ./manage.py migrate

docker-compose exec abtesting-service bash -c 'echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser(\'admin\', \'admin@ordergroove.com\', \'admin\')" | python manage.py shell'
docker-compose exec chrono bash -c 'echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser(\'admin\', \'admin@ordergroove.com\', \'admin\')" | python manage.py shell'
docker-compose exec moonshine bash -c 'echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser(\'admin\', \'admin@ordergroove.com\', \'admin\')" | python manage.py shell'

#
# Moonshine-api
#

docker-compose exec moonshine-api bash -c 'export PYTHONPATH=/usr/src/app && python feed/import_all.py env=dev'
