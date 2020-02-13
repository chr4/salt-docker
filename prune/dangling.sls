include:
  - docker.prune.timer

/etc/systemd/system/docker-prune.service:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://{{ slspath }}/docker-prune.service.jinja
    - template: jinja
    - defaults:
      all: false # Only remove dangling images
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/docker-prune.service
