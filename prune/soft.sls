# Deploy systemd-timer to cleanup (soft) docker images / containers automatically
docker-prune-soft.timer:
  service.running:
    - enable: true
    - watch:
      - file: /etc/systemd/system/docker-prune-soft.timer
    - require:
      - file: /etc/systemd/system/docker-prune-soft.timer
      - cmd: systemctl daemon-reload
  file.managed:
    - name: /etc/systemd/system/docker-prune-soft.timer
    - user: root
    - group: root
    - mode: 644
    - source: salt://{{ slspath }}/docker-prune-soft.timer
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/docker-prune-soft.timer

/etc/systemd/system/docker-prune-soft.service:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://{{ slspath }}/docker-prune-soft.service
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/docker-prune.service
