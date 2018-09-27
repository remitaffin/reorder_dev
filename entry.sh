#! /bin/bash

if [ -d "/usr/src/libraries/woodhouse" ]; then
  pip install -e /usr/src/libraries/woodhouse
fi

if [ -d "/usr/src/libraries/moonshine-core" ]; then
  pip install -e /usr/src/libraries/moonshine-core
fi

# create databases chrono, sms
# python manage.py migrate chrono, sms

# generate super user for chrono and moonshine-api
# echo "from django.contrib.auth import get_user_model; User = geer_model(); User.objects.create_superuser('admin', 'admin@ordergroove.com', 'admin')" | python manage.py shell

# import adventures moonshine-api
# export PYTHONPATH="${PYTHONPATH}:/usr/src/app/moonshine-api"
# python feed/import_all.py

# generate moonshine-api creds for chrono
# client_id=
# client_secret=

# generate chrono creds for moonshine-api
# chrono_auth_id=
# chrono_auth_secret=

# Wait for ampq to start before starting worker

exec "$@"
