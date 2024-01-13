#!/usr/bin/env bash
# Create a new user
# https://matrix-org.github.io/dendrite/administration/createusers
# REQUIRES
#     RUNNING dendrite instance
#     registration_shared_secret: "<SECRET HERE>" in dendrite.yaml
# add '-admin to end of call to create admin account'
# initial password can be set after call, as a prompt

docker exec -it dendrite-server /usr/bin/create-account -config ./dendrite.yaml -username $1
