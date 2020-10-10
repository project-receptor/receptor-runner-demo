#!/bin/bash

. ./test-env.sh

# Delete Receptor nodes
$CMD rm -f node1 node2 node3

# Delete custom network
$CMD network rm receptor

