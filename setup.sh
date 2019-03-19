#! /bin/bash

#
# Setup docker-compose services
#

# Create db
docker-compose up -d mariadb
sleep 10

# Create dbs
docker-compose exec mariadb mysql -u root -pogpassw -e "create database abtesting";
docker-compose exec mariadb mysql -u root -pogpassw -e "create database chrono";
docker-compose exec mariadb mysql -u root -pogpassw -e "create database moonshine";

# Migrate dbs
docker-compose run --rm abtesting-service ./manage.py migrate
docker-compose run --rm chrono ./manage.py migrate
docker-compose run --rm moonshine-api ./manage.py migrate

# Create admin users
docker-compose run --rm abtesting-service bash -c 'echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('"'admin'"', '"'admin@example.com'"', '"'pass'"')" | python manage.py shell'
docker-compose run --rm chrono bash -c 'echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('"'admin'"', '"'admin@example.com'"', '"'pass'"')" | python manage.py shell'
docker-compose run --rm moonshine-api bash -c 'echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('"'admin'"', '"'admin@example.com'"', '"'pass'"')" | python manage.py shell'

# Generate oauth app keys
docker-compose run --rm abtesting-service bash -c 'echo "from oauth2_provider.models import Application; Application.objects.create(client_id='"'abtesting-service-client-id'"', client_secret='"'abtesting-service-secret'"', user_id=1, client_type='"'public'"', name='"'admin app'"', authorization_grant_type='"'client-credentials'"')" | python manage.py shell'
docker-compose run --rm chrono bash -c 'echo "from oauth2_provider.models import Application; Application.objects.create(client_id='"'chrono-client-id'"', client_secret='"'chrono-secret'"', user_id=1, client_type='"'public'"', name='"'admin app'"', authorization_grant_type='"'client-credentials'"')" | python manage.py shell'
docker-compose run --rm moonshine-api bash -c 'echo "from oauth2_provider.models import Application; Application.objects.create(client_id='"'moonshine-api-client-id'"', client_secret='"'moonshine-api-secret'"', user_id=1, client_type='"'public'"', name='"'admin app'"', authorization_grant_type='"'client-credentials'"')" | python manage.py shell'

# Import adventures for moonshine-api
docker-compose run --rm moonshine-api bash -c 'export PYTHONPATH=/usr/src/app && python feed/import_all.py env=dev'

# Stop services
docker-compose stop
echo 'done!'
