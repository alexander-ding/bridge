#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- "$@"
fi
echo "***************************************************************************************"
echo "This container's internal IP:  $(hostname --ip-address)"

echo "***************************************************************************************"

exec "$@"
