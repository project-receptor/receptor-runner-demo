#!/bin/bash

# List of nodes
NODES="node1 node2 node3"
declare -A NODEIPS=( ["node1"]="172.30.99.11" ["node2"]="172.30.99.12" ["node3"]="172.30.99.13" )

# List of CAs to create and their node domain suffixes
declare -A CERTDOMAINS=(
  ["backend"]=".receptor"
  ["backend_client"]=".receptor"
  ["receptor"]=""
  ["receptor_client"]=""
)

# List of nodes to install certificates on
declare -A CERTINSTALL=(
  ["backend"]="node1 node3"
  ["backend_client"]="node2"
  ["receptor"]="node1 node2 node3"
  ["receptor_client"]="node1"
)

# Custom networks don't work with rootless podman, so try podman
# if it exists and we're root and i
if command -v podman > /dev/null && [ "$EUID" -eq 0 ]; then
  CMD=podman
elif command -v docker > /dev/null; then
  CMD=docker
else
  echo Could not find podman or docker
  exit 1
fi

# Set CMD here if you want to hard code one or the other
# CMD=podman
