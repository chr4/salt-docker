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
{% if salt.pillar.get('docker:daemon', undefined) is defined %}
  file.serialize:
    - name: /etc/docker/daemon.json
    - user: root
    - group: root
    - mode: 644
    - formatter: json
    - dataset_pillar: docker:daemon
{% else %}
  file.absent:
    - name: /etc/docker/daemon.json
{% endif %}

# Add users to docker group, so they can access docker
{% if salt.pillar.get('docker:users') %}
add_users_to_docker_group:
  group.present:
    - name: docker
    - members: {{ pillar['docker']['users'] }}
    - require:
      - pkg: docker
{% endif %}
