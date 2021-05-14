#!/bin/bash

echo '[Step 2 - Create hyperledger client / CLI node  '

echo '... setting region, stack name'
export REGION=us-east-1
export STACKNAME=non-profit-amb
echo '... running client cli node setup'
cd ~/non-profit-blockchain/ngo-fabric
./vpc-client-node.sh

cd ~