#!/bin/sh
set -e

echo "---> Attempting to restore Headscale database from Litestream replica if missing..."
litestream restore -if-db-not-exists -if-replica-exists /var/lib/headscale/db.sqlite

echo "---> Starting Litestream replication in the background..."
litestream replicate &
LITESTREAM_PID=$!

# Ensure litestream is killed if this script exits
trap "kill $LITESTREAM_PID" EXIT

echo "---> Starting Headscale server..."
exec headscale serve
