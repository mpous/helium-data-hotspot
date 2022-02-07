#!/bin/bash

echo "Starting start-gatewayrs.sh"

TARGET_DIR=/etc/helium_gateway

if [ ! -d ${TARGET_DIR} ] ; then
  # No directory mounted, better to exit than creating IDs inside a container
  echo "You must mount a persistent directory for /opt/helium_gateway"
  exit 1
fi

echo "Checking default.toml"

if [ ! -f ${TARGET_DIR}/default.toml ] ; then
  # The container has not been initialized
  # move the configuration file to the external directory
  echo "Initializing gatewayrs"
  cp -R /etc/helium_gateway/* ${TARGET_DIR}/

  # Add the ZONE in file
  if [ ! -z "${REGION_OVERRIDE}" ] ; then
    echo "Setting up Zone for ${REGION_OVERRIDE}"
    mv ${TARGET_DIR}/settings.toml ${TARGET_DIR}/settings.bak
    (echo "region=\"${REGION_OVERRIDE}\"" ; cat ${TARGET_DIR}/settings.bak ) > ${TARGET_DIR}/settings.toml
  fi

  if [ ! -z "${MINER_UPDATE}" ] ; then
    echo "Setting up auto update status ${MINER_UPDATE}"
    mv ${TARGET_DIR}/settings.toml ${TARGET_DIR}/settings.bak
    ( cat ${TARGET_DIR}/settings.bak ; echo "enabled=${MINER_UPDATE}" ) > ${TARGET_DIR}/settings.toml
  fi 
  
  # Check if the gateway_key already exists
  if [ -f ${TARGET_DIR}/gateway_key.bin ]; then
    echo "Key file already exists"
    echo "keypair = '\"${TARGET_DIR}\"/gateway_key.bin'" >> ${TARGET_DIR}/settings.toml
  else
      # Change the key path
      echo "Key file doesn't exist."
      mv ${TARGET_DIR}/settings.toml ${TARGET_DIR}/settings.bak
      ( echo "keypair = \"${TARGET_DIR}/gateway_key.bin\"" ; cat ${TARGET_DIR}/settings.bak ) > ${TARGET_DIR}/settings.toml
      rm ${TARGET_DIR}/settings.bak
  fi

  # Change the logger
  mv ${TARGET_DIR}/settings.toml ${TARGET_DIR}/settings.bak
  cat ${TARGET_DIR}/settings.bak | sed -e 's/syslog/stdio/' > ${TARGET_DIR}/settings.toml
  rm ${TARGET_DIR}/settings.bak

  # Change the listener
  mv ${TARGET_DIR}/settings.toml ${TARGET_DIR}/settings.bak
  cat ${TARGET_DIR}/settings.bak | sed -e 's/listen_addr/listen/' > ${TARGET_DIR}/settings.toml
  rm ${TARGET_DIR}/settings.bak

  echo "Ready to call helium_gateway server"

  /usr/bin/helium_gateway -c ${TARGET_DIR} server &
  sleep 3

  # Make the gateway key to be created
  /usr/bin/helium_gateway -c ${TARGET_DIR} key info
  GWNAME=`/usr/bin/helium_gateway -c ${TARGET_DIR} key info | grep name | tr -s " " | cut -d ':' -f 2 | sed -e 's/[ \"]//g'` 
  touch ${TARGET_DIR}/$GWNAME

  # Add the name of the hostpot into the tags
  #ID=$(curl -sX GET "https://api.balena-cloud.com/v5/device?\$filter=uuid%20eq%20'$BALENA_DEVICE_UUID'" \
  #-H "Content-Type: application/json" \
  #-H "Authorization: Bearer $BALENA_API_KEY" | \
  #jq ".d | .[0] | .id")

  #TAG_NAME=$(curl -sX POST \
  #"https://api.balena-cloud.com/v5/device_tag" \
  #-H "Content-Type: application/json" \
  #-H "Authorization: Bearer $BALENA_API_KEY" \
  #--data "{ \"device\": \"$ID\", \"tag_key\": \"NAME\", \"value\": \"$GWNAME\" }" > /dev/null)

else
   echo "Starting helium_gateway server"
   /usr/bin/helium_gateway -c ${TARGET_DIR} server
fi 