# dbus

A block that provides dbus allowing communication among services. Unlike the hostOS dbus in balenaOS, you can use this block as base and provide custom dbus configurations.

## How to use

Add the dbus block as a service in your docker-compose file

```yml
version: "2"
services:
  dbus:
    image: balenablocks/dbus
    restart: always
    privileged: true
```

The block exposes the following buses over tcp

- Session bus
- System bus

You need to configure the services where you need dbus to use the blocks address

Example:

```bash
export DBUS_SESSION_BUS_ADDRESS=tcp:host=dbus,port=55884
export DBUS_SYSTEM_BUS_ADDRESS=tcp:host=dbus,port=55887
```

## Customization

### Extend image configuration

You can extend the `dbus` block to include custom configuration as you would with any other Dockerfile. Just make sure you don't override the `ENTRYPOINT` as it contains important system configuration.

Example:

```dockerfile
FROM balenablocks/dbus

COPY example.conf /etc/dbus-1/system.d/

COPY mystartscript.sh /usr/src/

CMD [ "/bin/bash", "/usr/src/mystartscript.sh" ]

```

### Environment variables

| Environment variable | Description                               | Default | Options |
| -------------------- | ----------------------------------------- | ------- | ------- |
| `DBUS_SESSION_PORT`  | The port on which the session bus listens | 55884   | -       |
| `DBUS_SESSION_PORT`  | The port on which the system bus listens  | 55887   | -       |
