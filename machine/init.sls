# This state installs the Gitlab-maintained fork of docker-machine

# Note that docker-machine worker engines inherit their registry authentication from the
# controller, i.e. the node this state is deployed upon. Therefore this node should be
# authenticated against all relevant registries, which the workers will need to access.
# See state [docker.login], which is provided to achieve this.

{% set version = 'v0.16.2-gitlab.12' %}

include:
  - docker

# [show_changes] set to False, since the file is a binary and we don't want to diff those
/usr/local/bin/docker-machine:
  file.managed:
    - user: root
    - group: root
    - mode: 755
    - source: https://gitlab-docker-machine-downloads.s3.amazonaws.com/{{ version }}/docker-machine-Linux-x86_64
    # [show_changes] set to False, since the file is a binary and we don't want to diff those, a boolean on change is enough
    - show_changes: False
    - require:
      - pkg: docker
