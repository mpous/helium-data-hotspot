#!/bin/bash
echo "Starting client..."


export DBUS_SESSION_BUS_ADDRESS=tcp:host=dbus,port=55884


python client.py

balena-idle