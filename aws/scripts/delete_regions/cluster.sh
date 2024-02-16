#!/bin/bash
export AWS_PAGER=""

if [ -z "$1" ]; then
    echo "Error: Please provide the REGION as the first argument."
    exit 1
fi
REGION="$1"

STACKS=(
  "cluster-purplerelay-alarms"
  "cluster-purplerelay-ecs"
  "cluster-purplerelay-elb"
  "cluster-purplerelay-vpc"
  "cluster-pipeline"
)

for STACK_NAME in "${STACKS[@]}"; do
  aws cloudformation delete-stack \
    --stack-name "$STACK_NAME" \
    --region "$REGION" \

  aws cloudformation wait stack-delete-complete \
    --stack-name "$STACK_NAME" \
    --region "$REGION" \

  echo "Stack $STACK_NAME deleted successfully."
done

aws s3 rm s3://cluster-artifact-"$REGION" --recursive || \
  echo "The S3 bucket content doesn't exist or it's already deleted. Skipping deletion."


aws s3 rb s3://cluster-artifact-"$REGION" || \
  echo "The S3 bucket doesn't exist or it's already deleted. Skipping deletion."


aws iam delete-role-policy \
  --role-name cfn-cluster-pipeline-"$REGION" \
  --policy-name root || \
  echo "The role policy doesn't exist or it's already deleted. Skipping deletion."

aws iam delete-role \
  --role-name cfn-cluster-pipeline-"$REGION" || \
  echo "The role doesn't exist or it's already deleted. Skipping deletion."
