include:
  - docker.repository

# Install and configure docker
docker:
  pkg.installed:
    - pkgs: [docker-ce]
  service.running:
    - name: docker
    - enable: true
    - reload: true
    - watch:
      - pkg: docker
      - file: /etc/docker/daemon.json

# Deploy daemon.json if options are given in pillar.
# Make sure it's not existent if not.
{% set docker = pillar['docker']|default(false) %}
{% if docker['daemon'] is defined %}
  file.serialize:
    - name: /etc/docker/daemon.json
    - user: root
    - group: root
    - mode: 644
    - formatter: json
    - dataset_pillar: docker:options
{% else %}
  file.absent:
    - name: /etc/docker/daemon.json
{% endif %}
