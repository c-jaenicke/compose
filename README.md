# compose

Collection of compose files.

## int-docker-net

All the Compose files use a default network called `int-docker-net`.
This references an externally created Docker network, which can be created using the following command:

```bash
docker network create int-docker-net
```

## Reverse Proxy

The containers are exposed using [Traefik Proxy (traefik.io)](https://traefik.io/traefik/).
Only the Traefik service should be bound directly to the host machine.

## Treafik Labels

A list of commonly used labels to expose a service using Traefik. These labels are added to the service configuration in
the `docker-compose.yml` file.

```yaml
labels:
  # Enable Traefik discovery for this service
  - traefik.enable=true
  # Set entrypoint to HTTP
  #  - traefik.http.routers.<NAME>.entrypoints=web
  # Set entrypoint to HTTPS
  - traefik.http.routers.<NAME>.entrypoints=websecure
  # Bind to a domain or multiple domains (e.g., `DOMAIN`, `DOMAIN2`)
  - traefik.http.routers.<NAME>.rule=Host(`<DOMAIN>`)
  # Enable TLS
  - traefik.http.routers.<NAME>.tls=true
  # Set certificate resolver
  - traefik.http.routers.<NAME>.tls.certresolver=production
  # Enable Authentik protection for the service
  #  - traefik.http.routers.<NAME>.middlewares=authentik@file
```

The line `- traefik.http.routers.changedetection.middlewares=authentik@file` references a middleware service, Authentik.
See the `traefik/traefik.yml` file under the `# MIDDLEWARES` section to see how it is configured.

## Logging

### Disable

To disable logging for a container in the Docker Compose file, use the following configuration:

```yaml
    logging:
      driver: "none"
```

### Limit

For more details, refer to
the [official Docker documentation](https://docs.docker.com/compose/compose-file/compose-file-v3/#logging).

```yaml
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

The example above configures log rotation: it stores log files until they reach a maximum size of 200kB, after which
they are rotated. The max-file option specifies the maximum number of log files to retain. As logs grow beyond the
specified limits, older log files are removed to make space for new logs.

### Delete Logs

**This deletes all logs for this container. This action is non-reversible and may disrupt logging functionality.**

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
