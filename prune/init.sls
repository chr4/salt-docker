include:
  - docker.prune.timer

/etc/systemd/system/docker-prune.service:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://{{ tpldir }}/docker-prune.service.jinja
    - template: jinja
    - defaults:
      all: {{ salt['pillar.get']('docker:prune:all', true) }}
      volumes: {{ salt['pillar.get']('docker:prune:volumes', false) }}
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/docker-prune.service
