set shell := ["bash", "-cu"]

ansible *args='':
  #!/bin/env bash
  set -euo pipefail
  cd "./ansible"
  ansible-galaxy collection install -r requirements.yml --upgrade
  ansible-playbook --ask-become-pass playbook.yml {{args}}

packages *args='': (ansible "--tags" "packages" args)
dot *args='':      (ansible "--tags" "dot" args)
system *args='':   (ansible "--tags" "system" args)
web *args='':      (ansible "--tags" "web" args)
greetd *args='':   (ansible "--tags" "greetd" args)

dotenv:
  #!/bin/env bash
  pass-cli inject --in-file .env.template --out-file .env --force

gitleaks:
  #!/bin/env bash
  gitleaks git --redact --verbose --log-opts="--all"
