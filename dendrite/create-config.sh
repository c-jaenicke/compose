#!/usr/bin/env bash
# Create config
# Set domain and postgres db password here

docker run --rm --entrypoint="/bin/sh" \
  -v $(pwd)/config:/mnt \
  matrixdotorg/dendrite-monolith:latest \
  -c "/usr/bin/generate-config \
    -dir /var/dendrite/ \
    -db postgres://dendrite:<PASSWORD HERE>@postgres/dendrite?sslmode=disable \
    -server <DOMAIN HERE> > /mnt/dendrite.yaml"
