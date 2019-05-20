# Configuration was adapted from:
# http://btmiller.com/2016/11/27/docker-swarm-1.12-cluster-orchestration-with-saltstack.html

# Bootstrap the swarm leader
create-manager-mine-on-leader:
  salt.state:
    - sls: docker.manager.mine
    - tgt: {{ pillar['leader'] }}

# Update mine so we can use mine data to advert the correct manager IP
update-mine-on-leader:
  salt.function:
    - name: mine.update
    - tgt: {{ pillar['leader'] }}
    - require:
      - salt: create-manager-mine-on-leader

bootstrap-swarm-leader:
  salt.state:
    - sls: docker.manager.first
    - tgt: {{ pillar['leader'] }}
    - pillar:
        leader: {{ pillar['leader'] }}
    - require:
      - salt: update-mine-on-leader

# Add other nodes to the cluster (as managers)
{% for node in pillar['nodes'] %}

# Update mine so we can get the current token
update-swarm-leader-mine-{{ node }}:
  salt.function:
    - name: mine.update
    - tgt: {{ node }}
    - require:
      - salt: bootstrap-swarm-leader

# Join node
bootstrap-swarm-worker-{{ node }}:
  salt.state:
    - sls: docker.manager.join
    - tgt: {{ node }}
    - pillar:
        leader: {{ pillar['leader'] }}
    - require:
      - salt: bootstrap-swarm-leader
{% endfor %}
