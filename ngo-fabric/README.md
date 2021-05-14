# Part1: Build a Hyperledger Fabric blockchain network using Amazon Managed Blockchain

This section will build a Hyperledger Fabric blockchain network using Amazon Managed Blockchain. A combination of AWS CloudFormation, the AWS Console and the AWS CLI will be used. The process to create the network is as follows:

* Provision an AWS Cloud9 instance. We will use the Linux terminal that Cloud9 provides
* From Cloud9, run an AWS CloudFormation template to create a Fabric network and provision a peer node in Amazon Managed Blockchain 
* From Cloud9, run an AWS CloudFormation template to provision a VPC and a Fabric client node. You 
will use the Fabric client node to administer the Fabric network
* From the Fabric client node, create a Fabric channel, install and instantiate chaincode, and 
query and invoke transactions on the Fabric network

## Step 1 - Use Cloud9 to run inital network creation script
We will use AWS Cloud9 to provide a Linux terminal which has the AWS CLI already installed.

Note: If you have an existing Cloud9 environment left over from this tutorial that you would like to delete, run
```
aws cloud9  list-environments # Note environmentID of existing cloud9 environment
aws cloud9 delete-environment --environment-id <environmentID> 
```

1. Spin up a [Cloud9 IDE](https://us-east-1.console.aws.amazon.com/cloud9/home?region=us-east-1) from the AWS console.
In the Cloud9 console, click 'Create Environment'. Using 'us-east-1' for the region will be easier.
2. Provide a name for your environment, e.g. fabric-c9, and click **Next Step**
3. Select `Other instance type`, then select `t2.medium` and click **Next Step**
4. Click **Create environment**. It would typically take 30-60s to create your Cloud9 IDE
5. In the Cloud9 terminal, in the home directory, clone this repo:

```
cd ~
git clone https://github.com/ProsperiaInc/non-profit-blockchain.git
```

Update the AWS CLI and create, run the cloudformation templates that automatically stand up a network, member organization and peer node
```
cd ~
./non-profit-blockchain/ngo-fabric/tutorial-scripts/step-1.sh 
```

When the following command returns AVAILABLE you are ready to move on to the next step,
```
aws managedblockchain list-networks --query 'Networks[?Name==`ngo`].Status' | grep 'AVAILABLE'
```
This will take about 30 minutes so feel free to step away and return.


## Step 2 - Create the Fabric client node
In your Cloud9 terminal window.

Create the Fabric client node, which will host the Fabric CLI. You will use the CLI to administer
the Fabric network. The Fabric client node will be created in its own VPC in your AWS account, with VPC endpoints 
pointing to the Fabric network you created in Step 1 above. AWS CloudFormation will be used to create the Fabric 
client node, the VPC and the VPC endpoints. Note that the CloudFormation template includes an AMI that is available in us-east-1 only. If you want to run this workshop in a different AWS region, you will need to copy the AMI to your region and replace the AMI ID in the CloudFormation template. 

The AWS CloudFormation template requires a number of parameter values. The script you run below will make sure these 
are available as export variables before calling CloudFormation. 

If you see the following error when running the script below: `An error occurred (InvalidKeyPair.NotFound)`, ignore it.
This is caused by the script creating a keypair, and ensuring it does not overwrite it if it does exist.

In Cloud9:

```
cd ~
./non-profit-blockchain/ngo-fabric/tutorial-scripts/step-2.sh 
```

Check the progress in the AWS CloudFormation console and wait until the stack is CREATE COMPLETE.
You will find some useful information in the Outputs tab of the CloudFormation stack once the stack
is complete. We will use this information in later steps.

## Step 4 - Prepare the Fabric client node and enroll an identity
On the Fabric client node.

Prior to executing any commands on the Fabric client node, you will need to export ENV variables
that provide a context to Hyperledger Fabric. These variables will tell the client node which Fabric
network to use, which peer node to interact with, which TLS certs to use, etc. 

From Cloud9, SSH into the Fabric client node. The key (i.e. the .PEM file) should be in your home directory. We can grab the DNS name of the client node with the command below,

```
export EC2URL=`aws cloudformation describe-stacks --stack-name "ngo-fabric-client-node" | jq -r '.Stacks[0].Outputs[] | select (.OutputKey == "EC2URL").OutputValue'` 
```

And then we ssh to the client node; answer 'yes' if prompted: `Are you sure you want to continue connecting (yes/no)`

```
cd ~
ssh ec2-user@$EC2URL -i ~/ngo-keypair.pem
```

Clone the repo:

```
cd ~
git clone https://github.com/ProsperiaInc/non-profit-blockchain.git
```

In future steps you will need to refer to different configuration values in your Fabric network. In this step
we export these values so you don't need to copy them from the console, or look them up elsewhere. Source the file 
that includes the ENV export values that define your Fabric network configuration so that the exports are applied 
to your current session. If you exit the SSH session and re-connect, you'll need to source the file again.

We create an admin identity, enroll it with the AWS ManagedBlockchain CA, create a channel configuration and join the peer to the network.

You can do all of this in a single script, 
```
./non-profit-blockchain/ngo-fabric/tutorial-scripts/step-3.sh
```

## Step 5 - Install chaincode on your peer node
On the Fabric client node.

Finally, we want to install, instanstiate (on the network) chaincode. Then we want to do a transaction to verify that it works as expected.
This example chain code is [from fabric/integration](https://github.com/hyperledger/fabric/tree/main/integration/chaincode/simple).

You can do all of this in a single script, 
```
./non-profit-blockchain/ngo-fabric/tutorial-scripts/step-3.sh
```

The `simple` chaincode example queries two elements, `a` and `b` and sets them both to a value of 90. When the this script is finished the value of `90` should be displayed.

## Move on to Part 2
The workshop instructions can be found in the README files in parts 1-4:

* [Part 1:](../ngo-fabric/README.md) Start the workshop by building the Hyperledger Fabric blockchain network using Amazon Managed Blockchain.
* [Part 2:](../ngo-chaincode/README.md) Deploy the non-profit chaincode. 
* [Part 3:](../ngo-rest-api/README.md) Run the RESTful API server. 
* [Part 4:](../ngo-ui/README.md) Run the application. 
* [Part 5:](../new-member/README.md) Add a new member to the network. 
* [Part 6:](../ngo-lambda/README.md) Read and write to the blockchain with AWS Lambda.
* [Part 7:](../ngo-events/README.md) Use blockchain events to notify users of NGO donations.
* [Part 8:](../blockchain-explorer/README.md) Deploy Hyperledger Explorer. 
* [Part 9:](../ngo-identity/README.md) Integrating blockchain users with Amazon Cognito.
