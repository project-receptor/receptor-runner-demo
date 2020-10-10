#!/bin/bash
set -e

. ./test-env.sh

# Launch Ansible Runner job from node1 using a worker on node3
$CMD exec -it node1 bash -c 'ansible-runner transmit /demo -p test.yml |
  receptorctl work submit --node node3 --follow --rm runner --payload - |
  ansible-runner process /demo'

