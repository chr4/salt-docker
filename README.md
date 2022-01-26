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

### docker.login

Authenticate the system user `root` against a set of custom docker registries.
The registries and the respectively required credentials should be provided through pillar data.
This state primarily makes use of the `dockermod` salt module [documented here](https://docs.saltproject.io/en/latest/ref/modules/all/salt.modules.dockermod.html).
See `pillar.example` for further details.

### docker.machine

Substate to install `docker-machine`.
Since docker-machine is deprecated upstream, this state relies on the fork maintained by Gitlab.
See [releases](https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/releases) for available version strings for the `docker-machine:version` pillar key.

When docker-machine is executed for the first time, a set of keys and certificates are generated.
**The contents of these files must be manually generated and provided through pillar data.**
To generate these files, simply run `docker-machine create --driver <DRIVER> <OPTIONS> init-vm` on a pristine machine, i.e. one where docker-machine is installed but was never invoked.
This call should use the same `<DRIVER>` and `<OPTIONS>` that will later be used for regular operation.
The concrete driver and corresponding options are highly use-case dependent.

*Common pitfall:* The controller node must be able to talk to its spawned worker on TCP port `2376`, and the worker node must be capable to install OS package updates and the docker engine from the internet.
Ensure that `<OPTIONS>` sets suitable ingress and egress firewall rules.

Once `init-vm` has been fully provisioned it can be removed again with `docker-machine rm init-vm`.
The generated files are located in `/root/.docker/machine/certs/`.

See `pillar.example` on how to provision the contents of those key files.

Note that docker-machine worker engines inherit their registry authentication (more precisely, the full contents of `/root/.docker/config.json`) from the node on which docker-machine is executed.
Therefore this node should be authenticated against all relevant registries, which the workers will need to access.
See state `docker.login` above, which is provided to achieve this.

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
