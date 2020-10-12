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
for tlsname in "${!CERTDOMAINS[@]}"; do
  rm -f conf/*/${tlsname}_ca.crt
  rm -f conf/*/$tlsname.crt
  rm -f conf/*/$tlsname.key
  rm -f conf/*/$tlsname.req
  rm -f ca/$tlsname/pki/newcerts/*.pem
  rm -fd ca/$tlsname/pki/newcerts
  rm -f ca/$tlsname/pki/index.txt*
  rm -fd ca/$tlsname/pki
  rm -f ca/$tlsname/ca.crt
  rm -f ca/$tlsname/ca.key
  rm -fd ca/$tlsname
done
rm -fd ca
