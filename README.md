# Docker salt formula

This formula installs and configures Docker.

## States

### docker

Install docker, configure `daemon.json` according to the information in Salt pillar.
See `pillar.example` for configuration options.

### docker.prune

Setup a systemd timer that cleans up unused and dangling images every night by running
`docker system prune --force --all` automatically.

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
# Bootstrap nodes (from salt-master)
sudo salt "$allnodes" state.apply docker

# Restart salt-minion on swarm-manager node after docker.manager.mine was deployed
# NOTE: This command doesn't return, as salt-minion is stopped while command is run

sudo salt -N "$leader" cmd.run 'systemctl restart salt-minion'

# Bootstrap the cluster
sudo salt-run state.orch docker.orch.bootstrap-swarm pillar='{"leader": "$leader", "nodes": ["$2nd_node", "3rd_node"]}'
```
