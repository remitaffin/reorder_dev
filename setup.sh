#! /bin/bash

#
# Setup docker-compose services
#

function heading() {
  echo -e "\033[95m==========> $1\033[0m"
}

heading 'Starting...'

docker-compose up -d
./wait-for-it.sh --strict rabbitmq:5672 -t 60 -- echo 'rabbitmq is up'
./wait-for-it.sh --strict mariadb:3306 -t 60 -- echo 'mariadb is up'

sleep 5

heading 'Create DBs'
docker-compose exec mariadb mysql -u root -pogpassw -e "create database abtesting";
docker-compose exec mariadb mysql -u root -pogpassw -e "create database chrono";
docker-compose exec mariadb mysql -u root -pogpassw -e "create database moonshine";

heading 'Run migrations'
docker-compose exec abtesting-service ./manage.py migrate
docker-compose exec chrono ./manage.py migrate
docker-compose exec moonshine-api ./manage.py migrate

heading 'Create admin users'
docker-compose exec abtesting-service bash -c 'echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('"'admin'"', '"'admin@example.com'"', '"'pass'"')" | python manage.py shell' &> /dev/null
docker-compose exec chrono bash -c 'echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('"'admin'"', '"'admin@example.com'"', '"'pass'"')" | python manage.py shell' &> /dev/null
docker-compose exec moonshine-api bash -c 'echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('"'admin'"', '"'admin@example.com'"', '"'pass'"')" | python manage.py shell' &> /dev/null

heading 'Generate oauth app keys'
docker-compose exec abtesting-service bash -c 'echo "from oauth2_provider.models import Application; Application.objects.create(client_id='"'abtesting-service-client-id'"', client_secret='"'abtesting-service-secret'"', user_id=1, client_type='"'public'"', name='"'admin app'"', authorization_grant_type='"'client-credentials'"')" | python manage.py shell'
docker-compose exec chrono bash -c 'echo "from oauth2_provider.models import Application; Application.objects.create(client_id='"'chrono-client-id'"', client_secret='"'chrono-secret'"', user_id=1, client_type='"'public'"', name='"'admin app'"', authorization_grant_type='"'client-credentials'"')" | python manage.py shell'
docker-compose exec moonshine-api bash -c 'echo "from oauth2_provider.models import Application; Application.objects.create(client_id='"'moonshine-api-client-id'"', client_secret='"'moonshine-api-secret'"', user_id=1, client_type='"'public'"', name='"'admin app'"', authorization_grant_type='"'client-credentials'"')" | python manage.py shell'

heading 'Import adventures for moonshine-api'
docker-compose exec moonshine-api bash -c 'export PYTHONPATH=/usr/src/app && python feed/import_all.py env=dev'

heading 'done!'
