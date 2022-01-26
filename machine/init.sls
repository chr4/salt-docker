# This state installs the Gitlab-maintained fork of docker-machine

# Note that docker-machine worker engines inherit their registry authentication from the
# controller, i.e. the node this state is deployed upon. Therefore this node should be
# authenticated against all relevant registries, which the workers will need to access.
# See state [docker.login], which is provided to achieve this.

# We set the version from pillar-key [docker-machine:version] to simplify upgrades
{% set version = salt['pillar.get']('docker-machine:version') %}

include:
  - docker

/usr/local/bin/docker-machine:
  file.managed:
    - user: root
    - group: root
    - mode: 755
    - source: https://gitlab-docker-machine-downloads.s3.amazonaws.com/{{ version }}/docker-machine-Linux-x86_64
    # upstream (gitlab) does not provide a hash for this binary, so there is no point in storing a locally computed one
    - skip_verify: True
    # disable change diff, the file is a binary; a boolean on change is enough
    - show_changes: False
    - require:
      - pkg: docker

# Restore key files and certificates to cleanly initialise docker-machine.
#
# To generate the contents of these files: on a fresh instance, where docker-machine was never used,
# run [docker-machine create] with the correct driver, e.g. [--driver openstack], and all options (s.b.)
# required by that driver to cleanly ramp up and connect to a worker node (don't forget to allow the
# controller to access the new worker on TCP port 2376). Monitor the ramp-up with [docker-machine ls].
# When the ramp-up completes, the new node can be removed with [docker-machine rm <WORKER_ID>]. The
# required files should have been generated in [/home/root/.docker/machine/certs/].
#
# The correct set of driver options depends on how this docker-machine node will be used. For the case
# that this is the foundation of a gitlab-runner autoscaling solution, the options should match what
# will eventually be used in the /etc/gitlab-runner/config.toml.
#

/root/.docker/machine/certs/ca-key.pem:
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - makedirs: True
    - dir_mode: 700
    - contents_pillar: docker-machine:ca-key

/root/.docker/machine/certs/ca.pem:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - dir_mode: 700
    - contents_pillar: docker-machine:ca

/root/.docker/machine/certs/cert.pem:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - dir_mode: 700
    - contents_pillar: docker-machine:cert

/root/.docker/machine/certs/key.pem:
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - makedirs: True
    - dir_mode: 700
    - contents_pillar: docker-machine:key
