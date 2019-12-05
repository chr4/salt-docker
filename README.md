# Docker salt formula

This formula installs and configures Docker.

## States

### docker

Install docker, configure `daemon.json` according to the information in Salt pillar.
See `pillar.example` for configuration options.

### docker.prune

Setup a systemd timer that cleans up unused and dangling images every night by running
`docker system prune --force --all` automatically.

### docker.client.config

Deploys the file `~/.docker/config.json`, where `~` expands to the home dir of the user
running the minion-service. The contents of this file are read from the pillar key
`docker.client.config`. The main purpose here is to have a state where the salt-minion
user is already logged into private docker registries (as recorded in the client config file).
This in turn enables the subsequent setup of the state `docker_image.present` where the
image in question originates from said private registries.

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
