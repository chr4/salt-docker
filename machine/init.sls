# This is WIP, and currently does not actually install docker-machine (yet) but simply
# covers the preparation

include:
  - docker

# Docker machine worker engines inherit their registry authentication from the controller
# that runs docker machine, so this machine needs to be authenticated against all relevant
# registries. ensure that a pillar-key [*-docker-registries] is available
docker.login:
  module.run:
    - require:
        - pkg: docker-ce
