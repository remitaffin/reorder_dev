#! /bin/bash

if [ -d "/usr/src/libraries/moonshine-core" ]; then
  pip install -e /usr/src/libraries/moonshine-core
fi

if [ -d "/usr/src/libraries/ordergroove_nucleus" ]; then
  pip install -e /usr/src/libraries/ordergroove_nucleus
fi

if [ -d "/usr/src/libraries/woodhouse" ]; then
  pip install -e /usr/src/libraries/woodhouse
fi

if [ -d "/usr/src/libraries/whiskey" ]; then
  pip install -e /usr/src/libraries/whiskey
fi

# wait for rabbitmq
/usr/src/wait-for-it.sh rabbitmq:5672 -- echo 'rabbitmq is up'



exec "$@"
