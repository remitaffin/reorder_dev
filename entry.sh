#! /bin/bash

if [ -d "/usr/src/libraries/moonshine-core" ]; then
  pip install -e /usr/src/libraries/moonshine-core
fi

if [ -d "/usr/src/libraries/relay-models" ]; then
  pip install -e /usr/src/libraries/relay-models
fi

if [ -d "/usr/src/libraries/woodhouse" ]; then
  pip install -e /usr/src/libraries/woodhouse
fi

# wait for rabbitmq
/usr/src/wait-for-it.sh --strict -t 60 rabbitmq:5672 -- echo 'rabbitmq is up'

exec "$@"
