/etc/salt/minion.d/swarm.conf:
  file.managed:
    - source: salt://{{ slspath }}/swarm.conf
    - require:
      - pkg: docker
  service:
    - name: salt-minion
    - reload: true
    - watch:
      - file: /etc/salt/minion.d/swarm.conf
