{# We expect 'docker-users' to yield a dictionary, where each key maps to a list of usernames.
   The dictionary is the result of multiple merged pillar files targeted to this minion. The
   value() operation turns the dict into a list of lists of users. The sum(start=[]) filter
   is a fold that flattens this into a plain list of users and the unique filter removes
   potentially occurring duplicates.

   It is the users obligation to ensure that all users in `dockerusers` are actually present
   on this minion. Since we do not know the way in which users are placed on minions, i.e.
   thorugh which states, we cannot enforce this here with include directives.
#}

{% set dockerusers = pillar.get('docker-users', {}).values() | sum(start=[]) | unique %}

include:
  - docker

# Add users to docker group, so they can access docker
add_users_to_docker_group:
  group.present:
    - name: docker
    - members: {{dockerusers}}
    - require:
      - pkg: docker
