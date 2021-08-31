#!/bin/sh

source dbus-wait.sh

WIRELESS_INTERFACE=wlan0

DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket \
	./nm-manage-iface.sh $WIRELESS_INTERFACE false

wait_for_dbus \
	&& wpa_supplicant -u -B \
	&& connmand -n -i wlan0
