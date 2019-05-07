# Configuration was adapted from:
# http://btmiller.com/2016/11/27/docker-swarm-1.12-cluster-orchestration-with-saltstack.html

# Bootstrap the swarm leader
bootstrap-swarm-leader:
  salt.state:
    - sls: docker.manager.first
    - tgt: {{ pillar['leader'] }}

# Update docker mines
update-swarm-leader-mine:
  salt.function:
    - name: mine.update
    - tgt: {{ pillar['leader'] }}
    - require:
      - salt: bootstrap-swarm-leader

# Add other nodes to the cluster (as managers)
{% for node in pillar['nodes'] %}
bootstrap swarm worker {{ node }}:
  salt.state:
    - sls: docker.manager.join
    - tgt: {{ node }}
{% endfor %}
