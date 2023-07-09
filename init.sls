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

# Configure metrics in /etc/containerd/config.toml if options are given in pillar.
# In that case we're also interested to restart containerd on config changes.
# Add an empty line first to be sure there's some space between sections
{% set metrics = salt['pillar.get']('containerd:metrics', None)  -%}
{% if metrics is defined %}
containerd:
  pkg.installed:
    - pkgs: ['containerd.io']
  service.running:
    - name: containerd
    - enable: true
    - watch:
      - pkg: containerd
      - file: /etc/containerd/config.toml

/etc/containerd/config.toml:
  file.append:
    - text: |
        
        [metrics]
                address = "{{ metrics['address']  }}"
                {% if 'grpc_histogram' in metrics -%}
                grpc_histogram = {{ metrics['grpc_histogram']|lower }}
                {% endif -%}
{% endif %}
