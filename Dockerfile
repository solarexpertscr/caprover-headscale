FROM headscale/headscale:latest

# Create directory for configuration and data
RUN mkdir -p /etc/headscale /var/lib/headscale

# Copy configuration files
COPY config.yaml /etc/headscale/config.yaml
COPY acl.hujson /etc/headscale/acl.hujson

# Expose the main server port (CapRover will map this)
EXPOSE 8080

# Run headscale
CMD ["headscale", "serve"]
