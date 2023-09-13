# Setup official docker repository
{% if grains['osrelease']|float < 22.04  %}
{% set docker_repo_name = "deb [arch=amd64] https://download.docker.com/linux/" ~ grains['os']|lower ~ " " ~ grains['oscodename'] ~ " stable" %}
{% set apt_key = True %}
{% else %}
{% set docker_repo_name = "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/"
  ~ grains['os']|lower ~ " " ~ grains['oscodename'] ~ " stable" %}
{% set apt_key = False %}
{% endif %}

docker_prerequisites:
  pkg.installed:
    - pkgs: [apt-transport-https]

docker_repository:
  pkgrepo.managed:
    - name: {{ docker_repo_name }}
    - clean_file: True
    - aptkey: {{ apt_key }}
    - file: /etc/apt/sources.list.d/docker.list
    - key_url: https://download.docker.com/linux/ubuntu/gpg
    - require:
      - pkg: docker_prerequisites
    - require_in:
      - pkg: docker

# 24.0.3 has a bug that causes a sigsev when having certain Docker networking configs.
# This affected our Bitwarden instance.
#
# https://github.com/moby/moby/issues/45898
{% if grains['os_family'] == 'Debian' %}
/etc/apt/preferences.d/docker:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents:
{% for package in ['docker-ce', 'docker-ce-cli', 'docker-ce-rootless-extras'] %}
      - "Package: {{ package }}"
      - "Pin: version 5:24.0.3-1~{{ grains['os']|lower }}.{{ grains['osrelease'] }}~{{ grains['oscodename'] }}"
      - "Pin-Priority: -1\n\n"
{% endfor %}
    - require_in:
      - pkg: docker
{% endif %}
