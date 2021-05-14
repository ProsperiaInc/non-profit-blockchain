#!/bin/bash

echo '[Step 1 - includes tutorial prereq and step 1] '

echo '... Cloning this tutorial and setting up your CLI environment'
cd ~
git clone https://github.com/ProsperiaInc/non-profit-blockchain.git
sudo pip install awscli --upgrade

echo '... Cloning this tutorial and setting up your CLI environment'
echo '... Warning: this will take about 30 minutes. Go get coffee or something'

export REGION=us-east-1
export STACKNAME=non-profit-amb
cd ~/non-profit-blockchain/ngo-fabric
./amb.sh

echo '... Organization network, member and peer have been created!'