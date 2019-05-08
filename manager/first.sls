include:
  - docker
  - docker.manager.mine

{% set leader = salt.pillar.get('leader') %}
{% set manager_ip = salt.mine.get(leader, 'manager_ip')|dictsort|first|last|first %}

init new swarm cluster:
  cmd.run:
    - name: 'docker swarm init --advertise-addr {{ manager_ip }}'
    - require:
      - pkg: docker
