#!/usr/bin/env bash
set -e
source ./replicas.sh

# Description: Backend for replace operations.
#
# Disk: 128GB / non-persistent SSD
# Network: 100mbps
# Liveness probe: GET http://replacer:3185/healthz
# Ports exposed to other Sourcegraph services: 3185/TCP 6060/TCP
# Ports exposed to the public internet: none
#
docker run --detach \
    --name=replacer \
    --network=sourcegraph \
    --restart=always \
    --cpus=1 \
    --memory=512m \
    -e GOMAXPROCS=1 \
    -e SRC_FRONTEND_INTERNAL=sourcegraph-frontend-internal:3090 \
    -v ~/sourcegraph-docker/replacer-disk:/mnt/cache \
    index.docker.io/sourcegraph/replacer:3.14.0@sha256:8843d25125b8309623642fe22d9f4412e1c692ce3823b0bd2b5d924c4004808e

echo "Deployed replacer service"