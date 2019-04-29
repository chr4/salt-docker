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
    - source: salt://{{ slspath }}/docker-prune.timer
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/docker-prune.timer

/etc/systemd/system/docker-prune.service:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://{{ slspath }}/docker-prune.service
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/docker-prune.service
