#!/usr/bin/env bash
# Create a new user account for the dendrite instance
# Using first argument as username
# add -admin to add admin account
# https://matrix-org.github.io/dendrite/administration/createusers

docker exec -it dendrite-monolith /usr/bin/create-account -config /etc/dendrite/config/dendrite.yaml -username $1