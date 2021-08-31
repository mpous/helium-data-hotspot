#!/bin/sh

source dbus-wait.sh

DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket \
	./systemd-stop-unit.sh bluetooth.service

rfkill block bluetooth && rfkill unblock bluetooth
wait_for_dbus \
	&& /usr/lib/bluetooth/bluetoothd  --nodetach
