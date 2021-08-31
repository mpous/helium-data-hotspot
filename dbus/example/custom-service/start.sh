#!/bin/bash

echo "Starting service..."

# export DBUS_SESSION_BUS_ADDRESS=tcp:host=0.0.0.0,port=55884
export DBUS_SESSION_BUS_ADDRESS=tcp:host=dbus,port=55884
# export DBUS_SESSION_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket

python service.py

