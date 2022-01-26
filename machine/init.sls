# This state installs the Gitlab-maintained fork of docker-machine

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
