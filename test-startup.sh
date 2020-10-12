#!/bin/bash
set -e

. ./test-env.sh

for tlsname in "${!CERTDOMAINS[@]}"; do

  # Create the CA
  mkdir -p ca/$tlsname/pki/newcerts
  touch ca/$tlsname/pki/index.txt
  openssl genrsa -out ca/$tlsname/ca.key 2048
  openssl req -x509 -new -key ca/$tlsname/ca.key -out ca/$tlsname/ca.crt -subj "/C=US/ST=North Carolina/L=Durham/O=Red Hat/OU=Project Receptor/CN=Demo CA $tlsname"

  # Copy the CA cert to the node conf dirs
  for node in $NODES; do
    cp ca/$tlsname/ca.crt conf/$node/${tlsname}_ca.crt
  done
  
  # Generate the node certificates
  for node in ${CERTINSTALL[$tlsname]}; do
    openssl genrsa -out conf/$node/$tlsname.key 2048
    openssl req -key conf/$node/$tlsname.key -new -out conf/$node/$tlsname.req -subj "/C=US/ST=North Carolina/L=Durham/O=Red Hat/OU=Project Receptor/CN=$node${CERTDOMAINS[$tlsname]}"
    PKIDIR=ca/$tlsname/pki openssl ca -days 365 -notext -in conf/$node/$tlsname.req -out conf/$node/$tlsname.crt -cert ca/$tlsname/ca.crt -keyfile ca/$tlsname/ca.key -config openssl.cnf -batch
  done

done

# Get the base Receptor image
$CMD pull quay.io/project-receptor/receptor:latest
$CMD tag quay.io/project-receptor/receptor:latest receptor:latest

# Build the individual node images
for node in $NODES; do
  $CMD build containers/$node --tag receptor-$node:latest
done

# Create custom network
$CMD network create -d bridge \
  --subnet 172.30.99.0/24 \
  --gateway 172.30.99.1 \
  receptor

# Run the Receptor nodes
for node in $NODES; do
  $CMD run -d --rm \
    --name $node \
    --network receptor \
    --ip ${NODEIPS[$node]} \
    --add-host "node1.receptor:172.30.99.11" \
    --add-host "node2.receptor:172.30.99.12" \
    --add-host "node3.receptor:172.30.99.13" \
    --volume $PWD/conf/$node:/etc/receptor:Z \
    receptor-$node:latest
done

# Copy demo project to node1
$CMD cp $PWD/demo node1:/demo

# Wait for nodes to be known
ready=0
while [ "$ready" -eq 0 ]; do
  status=$($CMD exec node1 receptorctl status)
  echo "$status"
  ready=1
  for node in $NODES; do
    if ! echo "$status" | grep $node > /dev/null; then
      echo "Network not ready: $node not known"
      ready=0
    fi
  done
  if [ "$ready" -eq 0 ]; then
    sleep 1
    echo
  fi
done

