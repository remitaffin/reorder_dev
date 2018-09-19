#! /bin/bash

if [ -d "/usr/src/libraries/woodhouse" ]; then
  pip install -e /usr/src/libraries/woodhouse
fi

if [ -d "/usr/src/libraries/moonshine-core" ]; then
  pip install -e /usr/src/libraries/moonshine-core
fi

echo $SETTINGS_FILE

# create databases chrono, sms
# python manage.py migrate chrono, sms

# generate super user for chrono and moonshine-api
# echo "from django.contrib.auth import get_user_model; User = geer_model(); User.objects.create_superuser('admin', 'admin@ordergroove.com', 'admin')" | python manage.py shell

# generate moonshine-api creds for chrono
# client_id=
# client_secret=

# generate chrono creds for moonshine-api
# chrono_auth_id=
# chrono_auth_secret=

exec "$@"
