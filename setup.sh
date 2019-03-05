#! /bin/bash

#
# Setup Django apps
#

# Create db
mysql -h 127.0.0.1 -u root -pogpassw -e "create database abtesting";
mysql -h 127.0.0.1 -u root -pogpassw -e "create database chrono";
mysql -h 127.0.0.1 -u root -pogpassw -e "create database moonshine";

# Migrate db
docker-compose exec abtesting-service ./manage.py migrate
docker-compose exec chrono ./manage.py migrate
docker-compose exec moonshine-api ./manage.py migrate

# Create admin user
docker-compose exec abtesting-service bash -c 'echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('"'admin'"', '"'admin@example.com'"', '"'pass'"')" | python manage.py shell'
docker-compose exec chrono bash -c 'echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('"'admin'"', '"'admin@example.com'"', '"'pass'"')" | python manage.py shell'
docker-compose exec moonshine-api bash -c 'echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('"'admin'"', '"'admin@example.com'"', '"'pass'"')" | python manage.py shell'

# Generate oauth app keys
docker-compose exec abtesting-service bash -c 'echo "from oauth2_provider.models import Application; Application.objects.create(client_id='"'abtesting-service-client-id'"', client_secret='"'abtesting-service-secret'"', user_id=1, client_type='"'public'"', name='"'admin app'"', authorization_grant_type='"'client-credentials'"')" | python manage.py shell'
docker-compose exec chrono bash -c 'echo "from oauth2_provider.models import Application; Application.objects.create(client_id='"'chrono-client-id'"', client_secret='"'chrono-secret'"', user_id=1, client_type='"'public'"', name='"'admin app'"', authorization_grant_type='"'client-credentials'"')" | python manage.py shell'
docker-compose exec moonshine-api bash -c 'echo "from oauth2_provider.models import Application; Application.objects.create(client_id='"'moonshine-api-client-id'"', client_secret='"'moonshine-api-secret'"', user_id=1, client_type='"'public'"', name='"'admin app'"', authorization_grant_type='"'client-credentials'"')" | python manage.py shell'

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

#
# Call-me-maybe
#
# mysql -h 127.0.0.1 -u root -pogpassw -e "create database callmemaybe"; NOT SETUP YET
