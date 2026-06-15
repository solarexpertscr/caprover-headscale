FROM headscale/headscale:latest

# Install litestream
RUN apk add --no-cache curl

# Download and install Litestream
RUN curl -L -o /tmp/litestream.tar.gz https://github.com/benbjohnson/litestream/releases/latest/download/litestream-v0.3.13-linux-amd64.tar.gz && \
    tar -xzf /tmp/litestream.tar.gz -C /tmp && \
    mv /tmp/litestream /usr/local/bin/litestream && \
    chmod +x /usr/local/bin/litestream && \
    rm /tmp/litestream.tar.gz

# Create directory for configuration and data
RUN mkdir -p /etc/headscale /var/lib/headscale

# Copy configuration files
COPY config.yaml /etc/headscale/config.yaml
COPY acl.hujson /etc/headscale/acl.hujson
COPY litestream.yml /etc/litestream.yml
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Make entrypoint executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose the main server port (CapRover will map this)
EXPOSE 8080

# Use custom entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
