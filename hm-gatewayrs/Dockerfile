ARG SYSTEM_TIMEZONE=Europe/London
ARG GATEWAY_RS_RELEASE=v1.0.0-alpha.21

FROM balenalib/raspberry-pi-debian:buster-run

# Move to working directory
WORKDIR /opt/nebra-gatewayrs

ARG SYSTEM_TIMEZONE
ARG GATEWAY_RS_RELEASE
ENV GATEWAY_RS_RELEASE $GATEWAY_RS_RELEASE

# Intall dependencies
RUN \
    apt-get update && \
    DEBIAN_FRONTEND="noninteractive" \
    TZ="$SYSTEM_TIMEZONE" \
        apt-get -y install \
        wget=1.20.1-1.1 \
        python3=3.7.3-1 \
        ca-certificates=20200601~deb10u2 \
        --no-install-recommends && \
        apt-get autoremove -y && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*

# Pull in latest helium gatewayrs deb file and install
RUN wget https://github.com/helium/gateway-rs/releases/download/"$GATEWAY_RS_RELEASE"/helium-gateway-"$GATEWAY_RS_RELEASE"-raspi01.deb
RUN dpkg -i helium-gateway-*-raspi01.deb

# Copy start script and settings file
COPY start-gatewayrs.sh .
COPY keys.py .
COPY settings.toml.template /etc/helium_gateway/settings.toml.template

# Run start-gatewayrs script
ENTRYPOINT ["/opt/nebra-gatewayrs/start-gatewayrs.sh"]
