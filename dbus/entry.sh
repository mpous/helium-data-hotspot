#!/bin/bash

echo "balenaBlocks dbus version: $(cat VERSION)"

SESSION_PORT=${DBUS_SESSION_PORT:-55884}
SYSTEM_PORT=${DBUS_SYSTEM_PORT:-55887}

dbus-daemon --config-file=/usr/src/app/system.conf --fork --address=tcp:host=0.0.0.0,bind=0.0.0.0,port=$SYSTEM_PORT --print-address 

dbus-daemon --config-file=/usr/src/app/session.conf --address=tcp:host=0.0.0.0,bind=0.0.0.0,port=$SESSION_PORT --print-address

balena-idle