FROM headscale/headscale:v0.29.3

# Bumping this value forces CapRover to rebuild the image layer above, which
# re-pulls the pinned base image and re-copies the config files.
ARG CACHEBUST=2

# Copy valid configuration files
COPY config.yaml /etc/headscale/config.yaml
COPY acl.hujson /etc/headscale/acl.hujson

EXPOSE 8080

# Explicitly tell the container to run the server
CMD ["serve"]