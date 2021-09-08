#!/bin/bash

rm -f settings.toml
rm -f /etc/helium_gateway/settings.toml

if ! LISTEN_ADDR=$(/bin/hostname -i)
then
  echo "Can't get hostname"
  exit 1
else
  echo 'listen_addr = "'"${LISTEN_ADDR}"':1680"' >> settings.toml
fi

if [[ -v REGION_OVERRIDE ]]
then
  echo 'region = "'"${REGION_OVERRIDE}\"" >> settings.toml
else
  echo "REGION_OVERRIDE not set"
  exit 1
fi

if [ -f "/var/data/gateway_key.bin" ]
then
  echo "Key file already exists"
  echo 'keypair = "/var/data/gateway_key.bin"' >> settings.toml
else
  echo "Copying key file to persistent storage"
  if ! PUBLIC_KEYS=$(/usr/bin/helium_gateway -c /etc/helium_gateway key info)
  then
    echo "Can't get miner key info"
    exit 1
  else
    cp /etc/helium_gateway/gateway_key.bin /var/data/gateway_key.bin
    echo 'keypair = "/var/data/gateway_key.bin"' >> settings.toml
  fi
fi

echo "" >> settings.toml
cat /etc/helium_gateway/settings.toml.template >> settings.toml
cp settings.toml /etc/helium_gateway/settings.toml

if ! PUBLIC_KEYS=$(/usr/bin/helium_gateway -c /etc/helium_gateway key info)
then
  echo "Can't get miner key info"
  exit 1
else
  echo "$PUBLIC_KEYS" > /var/data/key_json
fi

python3 /opt/nebra-gatewayrs/keys.py

/usr/bin/helium_gateway -c /etc/helium_gateway server
