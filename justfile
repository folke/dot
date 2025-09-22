set shell := ["bash", "-cu"]


ansible tags='':
  #!/bin/env bash
  set -euo pipefail
  cd "./ansible"
  if [ -n "{{tags}}" ]; then
    ansible-playbook --ask-become-pass playbook.yml --tags "{{tags}}"
  else
    ansible-playbook --ask-become-pass playbook.yml
  fi

packages: (ansible "packages")
dot:      (ansible "dot")
system:   (ansible "system")
web:      (ansible "web")


