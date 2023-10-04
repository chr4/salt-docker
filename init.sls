include:
  - docker.repository

# Install and configure docker
docker:
  pkg.installed:
    - pkgs: [docker-ce]
  service.running:
    - name: docker
    - enable: true
    - reload: {{ pillar.get('docker').get('reload') | default('true') }}
    - watch:
      - pkg: docker
      - file: /etc/docker/daemon.json

# Deploy daemon.json if options are given in pillar.
# Make sure it's not existent if not.
{% if salt['pillar.get']('docker:daemon', None) != none %}
  file.serialize:
    - name: /etc/docker/daemon.json
    - user: root
    - group: root
    - mode: 644
    - formatter: json
    - makedirs: true
    - dataset_pillar: docker:daemon
{% else %}
  file.absent:
    - name: /etc/docker/daemon.json
{% endif %}

# Add users to docker group, so they can access docker
{% if salt['pillar.get']('docker:users', None) != none %}
add_users_to_docker_group:
  group.present:
    - name: docker
    - members: {{ salt['pillar.get']('docker:users') }}
    - require:
      - pkg: docker
{% endif %}
