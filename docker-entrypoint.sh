#!/bin/ash

set -e



if [ "$1" = 'tor' ]; then
    #chown -R tor:tor "/var/lib/tor"
    #exec gosu tor "$@"
    chown -R root:root "/var/lib/tor"
    exec "$@"
fi



exec "$@"

