#!/bin/bash
set -e

. ./test-env.sh

# Launch Ansible Runner job from node1 using a worker on node3
$CMD exec -it node1 bash -c 'ansible-runner transmit /demo -p test.yml |
  receptorctl work submit --node node3 --follow --rm --payload - --tlsclient receptor_client runner |
  ansible-runner process /demo'

