set shell := ["bash", "-cu"]


ansible tags='' *args='':
  #!/bin/env bash
  set -euo pipefail
  cd "./ansible"
  if [ -n "{{tags}}" ]; then
    ansible-playbook --ask-become-pass playbook.yml --tags "{{tags}}" {{args}}
  else
    ansible-playbook --ask-become-pass playbook.yml {{args}}
  fi

packages *args='': (ansible "packages" args)
dot *args='':      (ansible "dot" args)
system *args='':   (ansible "system" args)
web *args='':      (ansible "web" args)
greetd *args='':   (ansible "greetd" args)


