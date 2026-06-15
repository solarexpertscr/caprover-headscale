FROM headscale/headscale:latest

# Copy valid configuration files
# (COPY automatically creates parent directories like /etc/headscale)
COPY config.yaml /etc/headscale/config.yaml
COPY acl.hujson /etc/headscale/acl.hujson

# Expose the port Headscale listens on
EXPOSE 8080

# The official image defaults to running `headscale serve` as the `headscale` user