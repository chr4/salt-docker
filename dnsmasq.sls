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
{% set dnsmasq_override_file = '/etc/systemd/system/dnsmasq.service.d/override.conf' %}
dnsmasq_systemd_override:
  file.managed:
    - name: {{ dnsmasq_override_file }}
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - contents: |
      [Unit]
      After=docker.service
  cmd.run:
    - name: systemctl daemon-reload
      onchanges:
        - file: {{ dnsmasq_override_file }}