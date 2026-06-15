# Stage 1: Download and prepare litestream using Alpine
FROM alpine:latest AS litestream-builder
RUN apk add --no-cache curl tar
RUN curl -L -o /tmp/litestream.tar.gz https://github.com/benbjohnson/litestream/releases/download/v0.5.12/litestream-0.5.12-linux-x86_64.tar.gz && \
    tar -xzf /tmp/litestream.tar.gz -C /tmp && \
    mv /tmp/litestream /litestream && \
    chmod +x /litestream

# Stage 2: The final minimal Headscale image
FROM headscale/headscale:latest

# Copy the litestream binary from the Alpine builder stage
COPY --from=litestream-builder /litestream /usr/local/bin/litestream

# Copy configuration files 
# (Note: COPY automatically creates parent directories like /etc/headscale)
COPY config.yaml /etc/headscale/config.yaml
COPY acl.hujson /etc/headscale/acl.hujson
COPY litestream.yml /etc/litestream.yml
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Expose the main server port (CapRover will map this)
EXPOSE 8080

# Use custom entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]