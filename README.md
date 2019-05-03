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

### docker.pillar-users

Populate the `docker` group with a list of usernames extracted from Salt pillar data.
The pillar of the targeted minion should contain the following, where each subkey (`FIRSTSET`, `SECONDSET`, ...) and associated list of users may originate from a different pillar file targeted to the minion (e.g. due to overlapping wildcard matches in pillar targeting).

```
docker-users:
    ----------
    FIRSTSET:
        - user_A
        - user_B
    SECONDSET:
        - user_A
        - user_C
```

The resulting list of users in the dockergroup for this example would be `user_A, user_B, user_C`.
The given exampel pillar data would be the result of targeting both the following onto some minion:

```
docker-users:
    FIRSTSET:
        - user_A
        - user_B
```

```
docker-users:
    SECONDSET:
        - user_A
        - user_C
```
