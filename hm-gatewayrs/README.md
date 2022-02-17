# hm-gatewayrs

Light gateway container for Helium Network which builds the [gateway-rs](https://github.com/helium/gateway-rs) application into a docker container.

## Pre built containers

This repo automatically builds docker containers and uploads them to two repositories for easy access:
- [hm-gatewayrs on DockerHub](https://hub.docker.com/r/nebraltd/hm-gatewayrs)
- [hm-gatewayrs on GitHub Packages](https://github.com/NebraLtd/hm-gatewayrs/pkgs/container/hm-gatewayrs)

The images are tagged using the docker long and short commit SHAs for that release. The current version deployed to miners can be found in the [light-hotspot-software repo](https://github.com/NebraLtd/light-hotspot-software/blob/production/docker-compose.yml).
