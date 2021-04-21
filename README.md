# Docker salt formula

This formula installs and configures Docker.

## States

### docker

Install docker, configure `daemon.json` according to the information in Salt pillar.
See `pillar.example` for configuration options.

### docker.prune

Setup a systemd timer that cleans up unused and/or dangling images and/or unused volumes automatically every night, using `docker system prune`.

See `pillar.example` to configure clean up behavior.

### docker.compose

Install `docker-compose` package.

### docker.dnsmasq

Setup `dnsmasq` to listen as a DNS server on the docker gateway `172.17.0.1`. This is useful when dns servers configured on the host are ipv6 only
and docker is not configired with public ipv6 addresses because of lack of NAT.

- https://github.com/moby/libnetwork/issues/2557

Note: If dns servers specified on the host or via dns flags are unreachable from the containers then docker uses Google's public DNS server `8.8.8.8` for the containers.

- https://docs.docker.com/config/containers/container-networking/#dns-services

## Bootstrap cluster

This state configures Docker and Swarm. It defaults to use the interface `eth0` for internal communication.
The interface can be adjusted using the Pillar:

```yaml
docker:
  swarm:
    interface: ens3
```

```bash
# Bootstrap the cluster
sudo salt-run state.orch docker.orch.bootstrap-swarm pillar='{"leader": "$leader", "nodes": ["$2nd_node", "3rd_node"]}'
```
