{% set USER = grains['username'] %}

~/.docker:
  file.directory:
    - user: {{ USER }}
    - group: {{ USER }}
    - mode: 700

~/.docker/config.json:
  file.managed:
    - user: {{ USER }}
    - group: {{ USER }}
    - mode: 600
    - contents_pillar: docker.client.config
