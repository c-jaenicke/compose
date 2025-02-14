# compose/kasm-workspaces

1. Follow the instructions to install kasm workspaces <https://kasmweb.com/docs/latest/install/single_server_install.html>
2. Modify the `docker-compose.yaml` file in `/opt/kasm/<LATEST VERSION NUMBER HERE>/docker` 
3. Restart the service using `sudo bash /opt/kasm/current/bin/start`

**The `docker-compose.yaml` needs to be updated after every kasm workspace upgrade!**

## Traefik Configuration

You need to integrate the following in to your traefik `dynamic.yaml`:
```yaml
http:
  serversTransports:
    insecure-transport:
      insecureSkipVerify: true

  routers:
    kasm:
      rule: "Host(`DOMAIN_FOR_KASM`)"
      entryPoints:
        - "websecure"
      service: "kasm_service"
      tls:
        certResolver: "production"

  services:
    kasm_service:
      loadBalancer:
        servers:
          - url: "https://kasm_proxy:8443"
        serversTransport: "insecure-transport"
```