FROM headscale/headscale:latest

# Copy valid configuration files
COPY config.yaml /etc/headscale/config.yaml
COPY acl.hujson /etc/headscale/acl.hujson

# Ensure the data directory exists and is writable
RUN mkdir -p /var/lib/headscale && chown -R headscale:headscale /var/lib/headscale

EXPOSE 8080

# The official image defaults to running `headscale serve`