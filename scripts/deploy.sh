#!/usr/bin/env bash
#
# Build the site and publish it to the server.
#
# Run from the project root:
#   bash scripts/deploy.sh
#
# The server only ever receives static files. Node is never installed there.

set -euo pipefail

SERVER="leo@72.60.123.80"
REMOTE_PATH="/var/www/bentileo.tech"
BUILD_DIR="dist"

echo "Deploying bentileo.tech"

# 1. Build the static site
npm run build

# 2. Confirm the build produced something
if [ ! -f "${BUILD_DIR}/index.html" ]; then
    echo "Build produced no index.html. Stopping."
    exit 1
fi

# 3. Make every built file world-readable (directories traversable), so nginx
#    can serve it whatever the source files' permissions are. Owner-only files
#    return 403. Done here rather than with rsync --chmod, which the rsync that
#    ships with macOS does not support.
chmod -R a+rX "${BUILD_DIR}"

# 4. Copy to the server, deleting files that no longer exist locally
rsync --archive --delete --compress --human-readable \
      "${BUILD_DIR}/" "${SERVER}:${REMOTE_PATH}/"

echo "Deployed. https://bentileo.tech"
