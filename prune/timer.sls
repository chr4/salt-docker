# Deploy systemd-timer to cleanup Docker images/ containers automatically
docker-prune.timer:
  service.running:
    - enable: true
    - watch:
      - file: /etc/systemd/system/docker-prune.timer
    - require:
      - file: /etc/systemd/system/docker-prune.timer
      - cmd: systemctl daemon-reload
  file.managed:
    - name: /etc/systemd/system/docker-prune.timer
    - user: root
    - group: root
    - mode: 644
    - source: salt://{{ tpldir }}/docker-prune.timer.jinja
    - template: jinja
    - defaults:
      on_calendar: {{ salt['pillar.get']('docker:prune:on_calendar', '02:00') }}
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/docker-prune.timer
