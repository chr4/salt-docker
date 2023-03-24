dnsmasq:
  pkg.installed: []
  file.managed:
    - name: /etc/dnsmasq.conf
    - user: root
    - group: root
    - mode: 644
    - contents:
      # Explicitly bind dnsmasq to the docker0 interface
      # upstream DNS servers from /etc/resolv.conf will be used
      - "bind-interfaces"
      - "interface=docker0"
      - "listen-address=172.17.0.1"
      # Do not load /etc/hosts
      - "no-hosts"
      # Strictly follow the nameserver order in resolv.conf
      - strict-order
  service.running:
    - enable: true
    - watch:
      - pkg: dnsmasq
      - file: /etc/dnsmasq.conf

# It's necessary to start dnsmasq after Docker, so the docker0 interface is present.
# Otherwise, we'd get the following errors upon boot:
#
# dnsmasq: failed to create listening socket for 172.17.0.1: Cannot assign requested address
# dnsmasq: unknown interface docker0
dnsmasq_systemd_override:
  file.managed:
    - name: /etc/systemd/system/dnsmasq.service.d/after-docker.conf
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    - contents: |
        [Unit]
        After=docker.service
  cmd.run:
    - name: systemctl daemon-reload
      onchanges:
        - file: dnsmasq_systemd_override
