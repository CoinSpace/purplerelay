#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: Please provide the REGION as the first argument."
    exit 1
fi
REGION="$1"

if [ -z "$2" ]; then
    echo "Error: Please provide the Certificate-arn as the third argument."
    exit 1
fi
CERTIFICATE_ARN="$2"

if [ -z "$3" ]; then
    echo "Error: Please provide the Certificate-arn as the third argument."
    exit 1
fi
SecretARN="$3"

if [ -z "$4" ]; then
    echo "Error: Please provide the keypair name as the fourth argument."
    exit 1
fi
KEYPAIR="$4"

aws s3 rm s3://cluster-artifact-"$REGION" --recursive || {
  echo "The S3 bucket content doesn't exist or it's already deleted. Skipping deletion."
}

aws s3 rb s3://cluster-artifact-"$REGION" || {
  echo "The S3 bucket doesn't exist or it's already deleted. Skipping deletion."
}

aws iam delete-role-policy \
  --role-name cfn-cluster-pipeline-"$REGION" \
  --policy-name root || {
  echo "The role policy doesn't exist or it's already deleted. Skipping deletion."
}

aws iam delete-role \
  --role-name cfn-cluster-pipeline-"$REGION" || {
  echo "The role doesn't exist or it's already deleted. Skipping deletion."
}

aws cloudformation create-stack \
  --stack-name cluster-pipeline \
  --template-body file://../../cloudformation/cluster/codepipeline.yml \
  --parameters \
    ParameterKey=DefaultAcmCertificateArn,ParameterValue="$CERTIFICATE_ARN" \
    ParameterKey=SecretARN,ParameterValue="$SecretARN" \
    ParameterKey=KeyName,ParameterValue="$KEYPAIR" \
  --capabilities CAPABILITY_NAMED_IAM \
  --region "$REGION"
