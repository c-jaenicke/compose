# compose

Collection of compose files

Most of the compose files use [docker volumes (docker.com)](https://docs.docker.com/storage/volumes/) to store persistent data for containers. Only configuration files are binding to the host.

## int-docker-net

All of the compose files use a default network called `int-docker-net`.

This references an externally created docker network, created using:

```bash
docker network create int-docker-net
```

## Reverse Proxy

The container get exposed using [traefik Proxy (traefik.io)](https://traefik.io/traefik/).

Only the traefik and portainer services bind directly to the host machine.

## Treafik Labels

A list of commonly used labels to expose a service using treafik. These labels are appended to the service configuration in the `docker-compose.yml`.

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

This line `- traefik.http.routers.changedetection.middlewares=authelia@file` references a middleware service authelia. See the `traefik/traefik.yml` file, under the section `# MIDDLEWARES` to see how it is configured.


