#!/bin/bash

. ./test-env.sh

# Delete Receptor nodes
echo Removing nodes
$CMD rm -f node1 node2 node3

# Delete custom network
echo Removing network
$CMD network rm receptor

# Remove generated certificates
echo Removing certificates
rm -f conf/node2/ca.crt
rm -f ca/pki/newcerts/*.pem
rm -fd ca/pki/newcerts
rm -f ca/pki/index.txt*
rm -fd ca/pki
rm -f ca/ca.crt
rm -f ca/ca.key
rm -fd ca
