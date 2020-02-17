# Docker salt formula

This formula installs and configures Docker.

## States

### docker

Install docker, configure `daemon.json` according to the information in Salt pillar.
See `pillar.example` for configuration options.

### docker.prune

Setup a systemd timer that cleans up unused and/or dangling images automatically every night, using `docker system prune`.

- Use `docker.prune` (or `docker.prune.all`), to remove all unused and dangling images
- Use `docker.prune.dangling` to onle remove dangling images


### docker.compose

Install `docker-compose` package.


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
