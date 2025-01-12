#!/bin/bash

# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License is located at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# or in the "license" file accompanying this file. This file is distributed 
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either 
# express or implied. See the License for the specific language governing 
# permissions and limitations under the License.

echo Deleting any old stakcs
aws cloudformation delete-stack --stack-name $STACKNAME

echo Creating Amazon Managed Blockchain network, member and peer node
aws cloudformation deploy --stack-name $STACKNAME --template-file amb.yaml \
--parameter-overrides PeerNodeAvailabilityZone=${REGION}a \
--capabilities CAPABILITY_NAMED_IAM \
--region $REGION
