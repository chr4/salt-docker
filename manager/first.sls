include:
  - docker

# Mine data:
#   { "leader.tld": ['1.2.3.4'], "leader.tld": "TOKEN" }
{% set leader = pillar['leader'] %}
{% set manager_ip = salt['mine.get'](leader, 'docker.manager_ip')[leader]|first %}
{% set manager_token = salt['mine.get'](leader, 'docker.manager_token')[leader] %}

# Only init a new cluster if not already done so.
# When the cluster wasn't created, the following error is printed by Docker:
#   Error response from daemon: This node is not a swarm manager. Use "docker swarm init" or
#   "docker swarm join" to connect this node to swarm and try again.
{% if 'not a swarm manager' in manager_token %}
init new swarm cluster:
  cmd.run:
    - name: 'docker swarm init --advertise-addr {{ manager_ip }}'
    - require:
      - pkg: docker
{% endif %}
