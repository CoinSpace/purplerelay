#!/bin/bash

# set -x
TAG_KEY="Name"
TAG_VALUE="purplerelay-VPC"

REGIONS=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)

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

for region in $REGIONS; do
    vpcs=$(list_vpcs_with_tag $region)

    if [ -z "$vpcs" ]; then
        echo "No VPCs found with tag '$TAG_KEY:$TAG_VALUE' in region $region."
    else
        for vpc in $vpcs; do
            echo "Processing VPC $vpc in region $region..."
            peering_connections=$(aws ec2 describe-vpc-peering-connections --region $region \
                --filters "Name=requester-vpc-info.vpc-id,Values=$vpc" \
                --query "VpcPeeringConnections[].VpcPeeringConnectionId" --output text)

            for peering_id in $peering_connections; do
                echo "Deleting VPC peering connection $peering_id..."
                delete_vpc_peering $region $peering_id
            done
        done
    fi
done