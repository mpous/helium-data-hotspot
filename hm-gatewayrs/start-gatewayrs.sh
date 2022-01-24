#!/bin/bash

rm -f settings.toml
rm -f /etc/helium_gateway/settings.toml

echo "Checking for I2C device"

mapfile -t data < <(i2cdetect -y 1)

for i in $(seq 1 ${#data[@]}); do
    # shellcheck disable=SC2206
    line=(${data[$i]})
    # shellcheck disable=SC2068
    if echo ${line[@]:1} | grep -q 60; then
        echo "ECC is present."
        ECC_CHIP=True
    fi
done

if [[ -v REGION_OVERRIDE ]]
then
  echo 'region = "'"${REGION_OVERRIDE}\"" >> settings.toml
else
  echo "REGION_OVERRIDE not set"
  exit 1
fi

if [[ -v ECC_CHIP ]]
then
  echo "Using ECC for public key."
  echo 'keypair = "ecc://i2c-1:96&slot=0"' >> settings.toml
elif [ -f "/var/data/gateway_key.bin" ]
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
