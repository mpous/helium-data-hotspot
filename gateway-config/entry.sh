#!/bin/bash

set -e

source dbus-wait.sh

echo "Starting gateway_config"

wait_for_dbus \
	&& gateway_config/bin/gateway_config foreground
