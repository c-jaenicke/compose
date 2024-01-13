#!/usr/bin/env bash
# Generate keys for dendrite server

docker run --rm --entrypoint="/usr/bin/generate-keys" \
  -v $(pwd)/config:/mnt \
  matrixdotorg/dendrite-monolith:latest \
  -private-key /mnt/matrix_key.pem

#docker run --rm --entrypoint="" \
#  -v $(pwd):/mnt \
#  matrixdotorg/dendrite-monolith:latest \
#  /usr/bin/generate-keys \
#  -private-key /mnt/matrix_key.pem \
#  -tls-cert /mnt/server.crt \
#  -tls-key /mnt/server.key