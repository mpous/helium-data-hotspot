# Helium data-only Hotspot

This is a balena version based on the Nebra helium hotspot.

## Disclaimer

*This Helium Hotspot is going to transfer LoRa data to Helium but it's not going to perform proof-of-coverage or anything else to retrieve tokens. Read more information about the milestones and what's possible to get [here](https://docs.helium.com/mine-hnt/light-hotspots)*

## Requirements

### Hardware

* Raspberry Pi 3/4 or [balenaFin](https://www.balena.io/fin/)
* SD card in case of the RPi 3/4
* Power supply and (optionally) ethernet cable
* LoRa concentrator (SX1301 or SX1302) (e.g. [RAK2245](https://store.rakwireless.com/products/rak2245-pi-hat) and [RAK2287](https://www.rakwireless.com/en-us/products/lpwan-gateways-and-concentrators/rak2287))

### Software

* A balenaCloud account ([sign up here](https://dashboard.balena-cloud.com/))
* [balenaEtcher](https://balena.io/etcher)

## Deploy the fleet

Find 2 possibilities here:

### One-click deploy using [Balena Deploy](https://www.balena.io/docs/learn/deploy/deploy-with-balena-button/)

Running this project is as simple as deploying it to a balenaCloud application. You can do it in just one click by using the button below:

[![](https://www.balena.io/deploy.png)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/mpous/helium-data-hotspot)

Follow instructions, click Add a Device and flash an SD card with that OS image dowloaded from balenaCloud. Enjoy the magic 🌟Over-The-Air🌟!

### Deploy via [Balena CLI](https://www.balena.io/docs/reference/balena-cli/)

If you are a balena CLI expert, feel free to use [balena CLI](https://www.balena.io/docs/reference/balena-cli/). This option lets you configure in detail some options, like adding new services to your deploy or configure de DNS Server to use.

- Sign up on [balena.io](https://dashboard.balena.io/signup)
- Create a new fleet on balenaCloud.
- Click `Add a new device` and download the balenaOS image it creates.
- Burn and SD card (if using a Pi), connect it to the device and boot it up.

While the device boots (it will eventually show up in the balenaCloud dashboard) we will prepare de services:

- Clone this repository to your local workstation. Don't forget to update the submodules.
```
cd ~/workspace
git clone https://github.com/mpous/helium-data-hotspot
cd helium-data-hotspot
git submodule update --init
```
- Using [Balena CLI](https://www.balena.io/docs/reference/cli/), push the code to the fleet with `balena push <fleet-name>`
- See the magic happening, your device is getting updated 🌟Over-The-Air🌟!

## Device Variables

Once the device is online and the services `packet-forwarder` and `helium-miner` are downloaded and installed go to `Device Variables`:

* Create the variable for all the services `VARIANT` with your hardware definition (e.g. `DIY-RAK2287`). You can find here [the list of hardware compatible](https://github.com/NebraLtd/helium-hardware-definitions). 

* Create the variable for all the services `REGION_OVERRIDE` with your LoRa region (e.g. `EU868`). You can find here [the list of LoRa regions compatible](https://github.com/NebraLtd/hm-pktfwd).

At that moment the hotspot should be running showing some errors on connecting to the Blockchain on the balenaCloud Logs.


## Run the Helium Hotspot

To check that everything is running properly, go to the Terminal and select the `helium-miner` service, then introduce. 

`
helium_gateway key info
`

And you will get something like this:

`
{
  "address": <hotspot address>,
  "name": <hotspot name>
}
`

## Join the Helium blockchain with your data-only hotspot

To join the Helium blockchain, at the moment (summer 2021) you only can use the [Helium CLI](https://docs.helium.com/wallets/cli-wallet/). The Helium app is still not compatible with the data-only hotspots. Install the [Helium CLI](https://docs.helium.com/wallets/cli-wallet/) wallet and follow these steps:

### Create a Helium wallet

Install the Helium wallet CLI or use the wallet key from your mobile application. In case that you need to create a wallet from scratch, just type and follow the instructions.

```
helium-wallet create basic
```

Then to see `YOUR_WALLET` of the Helium wallet type:

```
helium-wallet info
```

### Add the hotspot from balenaCloud

Go to your device on balenaCloud and type on the HostOS terminal (before change `YOUR_WALLET` by your public Helium wallet ID):

```
root@d83bf778fc69:/etc/helium_gateway# helium_gateway add --owner YOUR_WALLET --payer YOUR_WALLET
{
  "address": "YOUR_ADDRESS",
  "fee": 65000,
  "mode": "dataonly",
  "owner": "YOUR_WALLET",
  "payer": "YOUR_WALLET",
  "staking fee": 1000000,
  "txn": "YOUR_TXN"
}
```

Remember that to confirm all the commands you will need to add `--commit` at the end of the command.

Then go to your computer where you installed the Helium wallet CLI software. Copy your `txn` from the previous JSON response and type:

```
MacBookPro-Marc-Pous-2827:helium-wallet-v1.6.6-x86-64-macos marcpous$ ./helium-wallet hotspots add YOUR_TXN --commit
Password: [hidden]
+-------------+-----------------------------------------------------+
| Key         | Value                                               |
+-------------+-----------------------------------------------------+
| Address     | YOUR_ADDRESS                                        |
+-------------+-----------------------------------------------------+
| Payer       | YOUR_WALLET                                         |
+-------------+-----------------------------------------------------+
| Fee         | 65000                                               |
+-------------+-----------------------------------------------------+
| Staking fee | 1000000                                             |
+-------------+-----------------------------------------------------+
| Hash        | YOUR_HASH                                           |
+-------------+-----------------------------------------------------+
```

You will need to have some Data Credits to be able to do this operation (1065000 DCs).

Finally you will need to assert the location of the data-only Helium hotspot. Cpy your 

```
MacBookPro-Marc-Pous-2827:helium-wallet-v1.6.6-x86-64-macos marcpous$ ./helium-wallet hotspots assert --gateway YOUR_ADDRESS --lat=YOUR_LAT --lon=YOUR_LON --mode dataonly --commit
Password: [hidden]
+------------------+-----------------------------------------------------+
| Key              | Value                                               |
+------------------+-----------------------------------------------------+
| Address          | YOUR_ADDRESS                                        |
+------------------+-----------------------------------------------------+
| Location         | LOCATION_HASH                                       |
+------------------+-----------------------------------------------------+
| Payer            | YOUR_WALLET                                         |
+------------------+-----------------------------------------------------+
| Nonce            | 1                                                   |
+------------------+-----------------------------------------------------+
| Fee (DC)         | 55000                                               |
+------------------+-----------------------------------------------------+
| Staking Fee (DC) | 500000                                              |
+------------------+-----------------------------------------------------+
| Gain (dBi)       | 1.2                                                 |
+------------------+-----------------------------------------------------+
| Elevation        | 0                                                   |
+------------------+-----------------------------------------------------+
| Hash             | YOUR_HASH                                           |
+------------------+-----------------------------------------------------+

```

And now that should have worked.

## Backup your gateway_key.bin file

*DISCLAIMER: It's very important that at this point you backup the gateway_key of your hotspot. If you loose this key, you will not be able to use this hotspot anymore.*

Follow this instructions to backup your `gateway_key.bin` file of your hotspot.

1. Open an SSH session to the "host-os" on balenaCloud Terminal
2. Type this command and keep note of the `(YOUR INSTANCE)_miner-storage`: `ls /var/lib/docker/volumes`
3. Type this command to get a link to download the gateway key (note to replace the `YOUR INSTANCE` part with the container number that you got from the previous command) `curl -F "file=@/var/lib/docker/volumes/(YOUR INSTANCE)_miner-storage/_data#/gateway_key.bin" https://file.io`
4. Use the outputted file.io link to securely download your swarm key. The link only works one time.

## Restore your gateway_key.bin file on your new file


1. Open an SSH session to the "host-os"
2. Type this command and keep note of the `(YOUR INSTANCE)_miner-storage` information: `ls /var/lib/docker/volumes`
3. Navigate to where the swarm_key is stored cd /var/lib/docker/volumes/(YOUR INSTANCE)_miner-storage/_data#/
4. Remove the original `gateway_key.bin` file `rm gateway_key.bin`
5. Upload your `gateway_key.bin` that you wish to restore onto file.io and do `curl -LJO [FILE.IO UPLOAD LINK]`
6. Reboot miner and you will see it restored :)


## Attributions

Thank you to Nebra for developing and balenifying the Helium Hotspot, Helium developers community, Travis and Joseph from balena to work on the dbus + conman issues.
