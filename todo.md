# TODO

## Reorder

create databases abtesting-service, chrono, sms (moonshine-api)
python manage.py migrate abtesting-service, chrono, sms

generate super user for abtesting-service, chrono, moonshine-api
echo "from django.contrib.auth import get_user_model; User = geer_model(); User.objects.create_superuser('admin', 'admin@ordergroove.com', 'admin')" | python manage.py shell

import adventures for moonshine-api
export PYTHONPATH="${PYTHONPATH}:/usr/src/app/moonshine-api"
python feed/import_all.py

Unsure how abtesting creds are used
og_testing_env=http://abtesting-service:8002

generate moonshine-api creds for chrono
client_id=
client_secret=

generate chrono creds for moonshine-api
chrono_auth_id=
chrono_auth_secret=


## Platform

Create database ordergroove
python lego/manage.py migrate --settings=lego.settings_local (Does not work, clone db)
https://ordergroove.atlassian.net/wiki/spaces/DEV/pages/48267266/Backend+environment+set-up
