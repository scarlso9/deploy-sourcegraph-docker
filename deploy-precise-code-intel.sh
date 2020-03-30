#!/usr/bin/env bash
set -e
source ./replicas.sh

# Description: Precise code intelligence services for Sourcegraph
#
# Disk: 200GB / persistent SSD
# Network: 100mbps
# Liveness probe: HTTP GET http://precise-code-intel:3186/healthz
# Ports exposed to other Sourcegraph services: 3186/TCP (server) 9090/TCP (prometheus)
# Ports exposed to the public internet: none
#
docker run --detach \
    --name=precise-code-intel \
    --network=sourcegraph \
    --restart=always \
    --cpus=2 \
    --memory=2g \
    -e GOMAXPROCS=2 \
    -e NUM_APIS=1 \
    -e NUM_BUNDLE_MANAGERS=1 \
    -e NUM_WORKERS=1 \
    -e PRECISE_CODE_INTEL_BUNDLE_MANAGER_URL=http://localhost:3187 \
    -e PRECISE_CODE_INTEL_API_SERVER_URL=http://localhost:3186 \
    -e LSIF_STORAGE_ROOT=/lsif-storage \
    -e SRC_FRONTEND_INTERNAL=sourcegraph-frontend-internal:3090 \
    -v ~/sourcegraph-docker/lsif-server-disk:/lsif-storage \
    index.docker.io/sourcegraph/lsif-server:3.14.0-1@sha256:ed683d2579d807458a892eab2f88fa5618b82a1ae7af02d5e7de1af3f6eea4a7

echo "Deployed precise-code-intel service"
