#!/bin/ash

set -e



if [ "$1" = 'tor' ]; then
    #chown -R tor:tor "/var/lib/tor"
    #exec gosu tor "$@"
    exec "$@"
fi



exec "$@"

