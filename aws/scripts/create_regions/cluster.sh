#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: Please provide the REGION as the first argument."
    exit 1
fi
REGION="$1"

if [ -z "$2" ]; then
    echo "Error: Please provide the codestar-connection arn as the second argument."
    exit 1
fi
CONNECTION_ARN="$2"

if [ -z "$3" ]; then
    echo "Error: Please provide the Certificate-arn as the third argument."
    exit 1
fi
CERTIFICATE_ARN="$3"

if [ -z "$4" ]; then
    echo "Error: Please provide the keypair name as the fourth argument."
    exit 1
fi
KEYPAIR="$4"

# if [ -z "$5" ]; then
#     echo "Error: Please provide the us-east-1 (N. Virginia) VPC id as the fourth argument."
#     exit 1
# fi
# CENTRALVPC="$5"

case "$REGION" in
  "us-east-1")
    CidrIp="10.10.0.0"
    IpPublicSubnet1="10.10.10.0"
    IpPublicSubnet2="10.10.20.0"
    IpPrivateSubnet1="10.10.30.0"
    IpPrivateSubnet2="10.10.40.0"
    ;;
  "us-east-2")
    CidrIp="10.20.0.0"
    IpPublicSubnet1="10.20.10.0"
    IpPublicSubnet2="10.20.20.0"
    IpPrivateSubnet1="10.20.30.0"
    IpPrivateSubnet2="10.20.40.0"
    ;;
  "us-west-1")
    CidrIp="10.30.0.0"
    IpPublicSubnet1="10.30.10.0"
    IpPublicSubnet2="10.30.20.0"
    IpPrivateSubnet1="10.30.30.0"
    IpPrivateSubnet2="10.30.40.0"
    ;;
  "us-west-2")
    CidrIp="10.40.0.0"
    IpPublicSubnet1="10.40.10.0"
    IpPublicSubnet2="10.40.20.0"
    IpPrivateSubnet1="10.40.30.0"
    IpPrivateSubnet2="10.40.40.0"
    ;;
  "af-south-1")
    CidrIp="10.50.0.0"
    IpPublicSubnet1="10.50.10.0"
    IpPublicSubnet2="10.50.20.0"
    IpPrivateSubnet1="10.50.30.0"
    IpPrivateSubnet2="10.50.40.0"
    ;;
  "ap-east-1")
    CidrIp="10.60.0.0"
    IpPublicSubnet1="10.60.10.0"
    IpPublicSubnet2="10.60.20.0"
    IpPrivateSubnet1="10.60.30.0"
    IpPrivateSubnet2="10.60.40.0"
    ;;
  "ap-south-1")
    CidrIp="10.70.0.0"
    IpPublicSubnet1="10.70.10.0"
    IpPublicSubnet2="10.70.20.0"
    IpPrivateSubnet1="10.70.30.0"
    IpPrivateSubnet2="10.70.40.0"
    ;;
  "ap-northeast-1")
    CidrIp="10.80.0.0"
    IpPublicSubnet1="10.80.10.0"
    IpPublicSubnet2="10.80.20.0"
    IpPrivateSubnet1="10.80.30.0"
    IpPrivateSubnet2="10.80.40.0"
    ;;
  "ap-northeast-2")
    CidrIp="10.90.0.0"
    IpPublicSubnet1="10.90.10.0"
    IpPublicSubnet2="10.90.20.0"
    IpPrivateSubnet1="10.90.30.0"
    IpPrivateSubnet2="10.90.40.0"
    ;;
  "ap-southeast-1")
    CidrIp="10.15.0.0"
    IpPublicSubnet1="10.15.10.0"
    IpPublicSubnet2="10.15.20.0"
    IpPrivateSubnet1="10.15.30.0"
    IpPrivateSubnet2="10.15.40.0"
    ;;
  "ap-southeast-2")
    CidrIp="10.25.0.0"
    IpPublicSubnet1="10.25.10.0"
    IpPublicSubnet2="10.25.20.0"
    IpPrivateSubnet1="10.25.30.0"
    IpPrivateSubnet2="10.25.40.0"
    ;;
  "ca-central-1")
    CidrIp="10.35.0.0"
    IpPublicSubnet1="10.35.10.0"
    IpPublicSubnet2="10.35.20.0"
    IpPrivateSubnet1="10.35.30.0"
    IpPrivateSubnet2="10.35.40.0"
    ;;
  "eu-central-1")
    CidrIp="10.45.0.0"
    IpPublicSubnet1="10.45.10.0"
    IpPublicSubnet2="10.45.20.0"
    IpPrivateSubnet1="10.45.30.0"
    IpPrivateSubnet2="10.45.40.0"
    ;;
  "eu-west-1")
    CidrIp="10.55.0.0"
    IpPublicSubnet1="10.55.10.0"
    IpPublicSubnet2="10.55.20.0"
    IpPrivateSubnet1="10.55.30.0"
    IpPrivateSubnet2="10.55.40.0"
    ;;
  "eu-west-2")
    CidrIp="10.65.0.0"
    IpPublicSubnet1="10.65.10.0"
    IpPublicSubnet2="10.65.20.0"
    IpPrivateSubnet1="10.65.30.0"
    IpPrivateSubnet2="10.65.40.0"
    ;;
  "eu-west-3")
    CidrIp="10.75.0.0"
    IpPublicSubnet1="10.75.10.0"
    IpPublicSubnet2="10.75.20.0"
    IpPrivateSubnet1="10.75.30.0"
    IpPrivateSubnet2="10.75.40.0"
    ;;
  "eu-north-1")
    CidrIp="10.85.0.0"
    IpPublicSubnet1="10.85.10.0"
    IpPublicSubnet2="10.85.20.0"
    IpPrivateSubnet1="10.85.30.0"
    IpPrivateSubnet2="10.85.40.0"
    ;;
  "eu-south-1")
    CidrIp="10.95.0.0"
    IpPublicSubnet1="10.95.10.0"
    IpPublicSubnet2="10.95.20.0"
    IpPrivateSubnet1="10.95.30.0"
    IpPrivateSubnet2="10.95.40.0"
    ;;
  "me-south-1")
    CidrIp="10.105.0.0"
    IpPublicSubnet1="10.105.10.0"
    IpPublicSubnet2="10.105.20.0"
    IpPrivateSubnet1="10.105.30.0"
    IpPrivateSubnet2="10.105.40.0"
    ;;
  "sa-east-1")
    CidrIp="10.115.0.0"
    IpPublicSubnet1="10.115.10.0"
    IpPublicSubnet2="10.115.20.0"
    IpPrivateSubnet1="10.115.30.0"
    IpPrivateSubnet2="10.115.40.0"
    ;;
esac

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
    ParameterKey=ConnectionArn,ParameterValue="$CONNECTION_ARN" \
    ParameterKey=DefaultAcmCertificateArn,ParameterValue="$CERTIFICATE_ARN" \
    ParameterKey=KeyName,ParameterValue="$KEYPAIR" \
    ParameterKey=CidrIp,ParameterValue="$CidrIp" \
    ParameterKey=IpPublicSubnet1,ParameterValue="$IpPublicSubnet1" \
    ParameterKey=IpPublicSubnet2,ParameterValue="$IpPublicSubnet2" \
    ParameterKey=IpPrivateSubnet1,ParameterValue="$IpPrivateSubnet1" \
    ParameterKey=IpPrivateSubnet2,ParameterValue="$IpPrivateSubnet2" \
  --capabilities CAPABILITY_NAMED_IAM \
  --region "$REGION"

# chmod +x ./vpc_peering.sh
# ./vpc_peering.sh