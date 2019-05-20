# Mine data:
#   { "leader.tld": ['1.2.3.4'], "leader.tld": "TOKEN" }
{% set leader = pillar['leader'] %}
{% set manager_ip = salt['mine.get'](leader, 'docker.manager_ip')[leader]|first %}
{% set manager_token = salt['mine.get'](leader, 'docker.manager_token')[leader] %}

# TODO: raise when not set

include:
  - docker

join cluster:
  cmd.run:
    - name: 'docker swarm join --token {{ manager_token }} {{ manager_ip }}:2377'
    - require:
      - pkg: docker
