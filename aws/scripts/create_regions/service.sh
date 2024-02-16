#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: Please provide the REGION as the first argument."
    exit 1
fi
REGION="$1"

if [ -z "$3" ]; then
    echo "Error: Please provide the Certificate-arn as the third argument."
    exit 1
fi
CERTIFICATE_ARN="$3"

aws s3 rm s3://service-artifact-"$REGION" --recursive || \
  echo "The S3 bucket content doesn't exist or it's already deleted. Skipping deletion."


aws s3 rb s3://service-artifact-"$REGION" || \
  echo "The S3 bucket doesn't exist or it's already deleted. Skipping deletion."


aws iam delete-role-policy \
  --role-name cfn-service-pipeline-"$REGION" \
  --policy-name root || \
  echo "The role policy doesn't exist or it's already deleted. Skipping deletion."


aws iam delete-role \
  --role-name cfn-service-pipeline-"$REGION" || \
  echo "The role doesn't exist or it's already deleted. Skipping deletion."


aws ecr delete-repository \
  --repository-name purplerelay \
  --region $REGION \
  --force || \
  echo "The repository doesn't exist or it's already deleted. Skipping deletion."

aws cloudformation create-stack \
  --stack-name service-pipeline \
  --template-body file://../../cloudformation/service/codepipeline.yml \
  --parameters \
    ParameterKey=DefaultAcmCertificateArn,ParameterValue="$CERTIFICATE_ARN" \
  --capabilities CAPABILITY_NAMED_IAM \
  --region "$REGION"
