{% set leader = salt.pillar.get('leader') %}
{% set manager_token = salt.mine.get(leader, 'manager_token')|dictsort|first|last %}
{% set manager_ip = salt.mine.get(leader, 'manager_ip')|dictsort|first|last|first %}

include:
  - docker
  - docker.manager.mine

join cluster:
  cmd.run:
    - name: 'docker swarm join --token {{ manager_token }} {{ manager_ip }}:2377'
    - require:
      - pkg: docker
