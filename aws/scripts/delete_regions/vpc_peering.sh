#!/bin/bash

# set -x
TAG_KEY="Name"
TAG_VALUE="purplerelay-VPC"
REGION=$1

list_vpcs_with_tag() {
    region=$1
    aws ec2 describe-vpcs --region $region \
        --filters "Name=tag-key,Values=$TAG_KEY" "Name=tag-value,Values=$TAG_VALUE" \
        --query "Vpcs[].VpcId" --output text
}

delete_vpc_peering() {
    region=$1
    vpc_peering_id=$2
    aws ec2 delete-vpc-peering-connection --region $region --vpc-peering-connection-id $vpc_peering_id
}

vpc=$(list_vpcs_with_tag $REGION)

if [ -z "$vpc" ]; then
    echo "No VPCs found with tag '$TAG_KEY:$TAG_VALUE' in region $REGION."
else
    echo "Processing VPC $vpc in region $REGION..."
    peering_connections1=$(aws ec2 describe-vpc-peering-connections --region $REGION \
        --filters "Name=requester-vpc-info.vpc-id,Values=$vpc" \
        --query "VpcPeeringConnections[].VpcPeeringConnectionId" --output text)
    for peering_id in $peering_connections1; do
        echo "Deleting VPC peering connection $peering_id..."
        delete_vpc_peering $REGION $peering_id
    done

    peering_connections2=$(aws ec2 describe-vpc-peering-connections --region $REGION \
        --filters "Name=accepter-vpc-info.vpc-id,Values=$vpc" \
        --query "VpcPeeringConnections[].VpcPeeringConnectionId" --output text)
    for peering_id in $peering_connections2; do
        echo "Deleting VPC peering connection $peering_id..."
        delete_vpc_peering $REGION $peering_id
    done

fi