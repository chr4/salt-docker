# This is WIP, and currently does not actually install docker-machine (yet) but simply
# covers the preparation

include:
  - docker

python3-pip:
  pkg.installed

install_python_lib_for_docker_via_pip:
  pip.installed:
    - name: docker
    - require:
      - pkg: python3-pip

# Docker machine worker engines inherit their registry authentication from the controller
# that runs docker machine, so this machine needs to be authenticated against all relevant
# registries. ensure that a pillar-key [*-docker-registries] is available
authenticate_root_with_docker_registries:
  module.run:
    - docker.login:
    - require:
      - service: docker
