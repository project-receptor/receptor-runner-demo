#!/bin/bash
set -e

. ./test-env.sh

# Create custom network
$CMD network create -d bridge \
  --subnet 172.30.99.0/24 \
  --gateway 172.30.99.1 \
  receptor

# Get the image
$CMD pull quay.io/project-receptor/receptor:latest
$CMD tag quay.io/project-receptor/receptor:latest receptor:latest

# Run Receptor nodes
for node in node1 node2 node3; do
  $CMD run -d --rm \
    --name $node \
    --hostname "$node.receptor" \
    --network receptor \
    --volume $PWD/$node:/etc/receptor:Z \
    receptor:latest
done

# Install Ansible Runner in node1 and node3
for node in node1 node3; do
  $CMD exec $node bash -c 'dnf -y install git gcc python-devel &&
    pip install git+https://github.com/ansible/ansible-runner' &
done
wait

# Copy demo project to node1
$CMD cp $PWD/demo node1:/demo

# Install Ansible itself in node3
$CMD exec node3 bash -c 'pip install ansible'

# Show Receptor status
$CMD exec node1 receptorctl status
