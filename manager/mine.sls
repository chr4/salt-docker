include:
  - docker

/etc/salt/minion.d/swarm.conf:
  file.managed:
    - source: salt://{{ slspath }}/swarm.conf.jinja
    - template: jinja
    - defaults:
      swarm_interface: {{ salt['pillar.get']('docker:swarm:interface', 'eth0') }}
    - require:
      - pkg: docker

  # Restarting salt-minion, because mine.update from orch doesn't work
  service.running:
    - name: salt-minion
    - watch:
      - file: /etc/salt/minion.d/swarm.conf
