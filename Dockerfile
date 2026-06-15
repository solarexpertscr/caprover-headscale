FROM headscale/headscale:latest

# Cache buster to force fresh pull of config
ARG CACHEBUST=2

# Copy valid configuration files
COPY config.yaml /etc/headscale/config.yaml
COPY acl.hujson /etc/headscale/acl.hujson

EXPOSE 8080

# Explicitly tell the container to run the server
CMD ["serve"]