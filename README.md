# Docker salt formula

This formula installs and configures Docker.

## States

### docker

Install docker, configure `daemon.json` according to the information in Salt pillar.
See `pillar.example` for configuration options.

### docker.prune

Setup a systemd timer that cleans up unused and dangling images every night by running
`docker system prune --force --all` automatically.
