# compose

Collection of compose files

Most of the compose files use [docker volumes (docker.com)](https://docs.docker.com/storage/volumes/) to store
persistent data for containers. Only configuration files are binding to the host.

## int-docker-net

All the compose files use a default network called `int-docker-net`.

This references an externally created docker network, created using:

```bash
docker network create int-docker-net
```

## Reverse Proxy

The containers get exposed using [traefik Proxy (traefik.io)](https://traefik.io/traefik/).

Only the traefik and portainer services bind directly to the host machine.

## Treafik Labels

A list of commonly used labels to expose a service using treafik. These labels are appended to the service configuration
in the `docker-compose.yml`.

```yaml
    labels:
      # enable treafik discovery for this service
      - traefik.enable=true
      # set entrypoint to http
      #  - traefik.http.routers.<NAME>.entrypoints=web
      # set entrypoint to https
      - traefik.http.routers.<NAME>.entrypoints=websecure
      # bind to a domain or multiple ones using (`DOMAIN`, `DOMAIN2`)
      - traefik.http.routers.<NAME>.rule=Host(`<DOMAIN>`)
      # enable tls
      - traefik.http.routers.<NAME>.tls=true
      # set cert server
      - traefik.http.routers.<NAME>.tls.certresolver=production
    # enable authelia for service, make sure service is in authelia config
    #  - traefik.http.routers.<NAME>.middlewares=authelia@file
```

This line `- traefik.http.routers.changedetection.middlewares=authelia@file` references a middleware service authelia.
See the `traefik/traefik.yml` file, under the section `# MIDDLEWARES` to see how it is configured.

## Logging

### Disable

Disable logging for a container in the docker compose file.

```yaml
    logging:
      driver: none
```

### Limit

<https://docs.docker.com/compose/compose-file/compose-file-v3/#logging>

```yaml
    logging:
      options:
        max-size: "200k"
        max-file: "10"
```

*The example shown above would store log files until they reach a max-size of 200kB,
and then rotate them. The amount of individual log files stored is specified by the max-file value.
As logs grow beyond the max limits, older log files are removed to allow storage of new logs.*

### Delete Logs

**Deletes all Logs for this container. Non-reversible. Can break logs.**

```shell
truncate -s 0 $(docker inspect --format='{{.LogPath}}' <container_name_or_id>)
```

### View Logs and Follow

```shell
docker compose logs -f <container name>
```

### Using Graylog

```yaml
    logging:
      driver: gelf
      options:
        # this references the static ip given to the graylog container
        # port is standard is a gelf udp note, created in web ui
        gelf-address: "udp://172.19.200.1:12201"
        tag: <service-name>
```

## Update Running Compose stack

```shell
docker compose pull && docker compose down && docker compose up -d
```

Quick copy for sudo:

```shell
sudo docker compose pull && sudo docker compose down && sudo docker compose up -d
```
