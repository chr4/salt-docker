# Setup official docker repository
apt-transport-https:
  pkg.installed: []

docker_repository:
  pkgrepo.managed:
    - name: deb [arch=amd64] https://download.docker.com/linux/{{ grains['os']|lower }} {{ grains['oscodename'] }} stable
    - file: /etc/apt/sources.list.d/docker.list
    - key_url: https://download.docker.com/linux/ubuntu/gpg
    - require:
      - pkg: apt-transport-https
    - require_in:
      - pkg: docker

# Make sure 20.10.2 is not installed, as it messes up binding to ipv6 on the host
# See:
# - https://github.com/moby/libnetwork/issues/2607
# - https://github.com/moby/libnetwork/pull/2608
{% if grains['os_family'] == 'Debian' %}
/etc/apt/preferences.d/docker:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents:
      - "Package: docker-ce"
      - "Pin: version 5:20.10.2~3-0~{{ grains['os']|lower }}-{{ grains['oscodename'] }}"
      - "Pin-Priority: -1"
    - require_in:
      - pkg: docker
{% endif %}
