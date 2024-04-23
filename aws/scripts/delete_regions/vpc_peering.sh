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

route_table_id=$(aws ec2 describe-route-tables \
    --region $REGION \
    --filters "Name=tag:Name,Values=purplerelay-PrivateRouteTable" \
    --query "RouteTables[].RouteTableId" \
    --output text)

echo "route table: $route_table_id"

cidr_block=$(aws ec2 describe-vpcs \
    --region $REGION \
    --filters "Name=tag-key,Values=Name" "Name=tag-value,Values=purplerelay-VPC" \
    --query "Vpcs[].CidrBlock" \
    --output text)

routes=$(aws ec2 describe-route-tables \
    --region $REGION \
    --route-table-id $route_table_id \
    --query "RouteTables[0].Routes" \
    --output json)

for route in $(echo $routes | jq -c '.[]'); do
    destination_cidr=$(echo $route | jq -r '.DestinationCidrBlock')

    if [ "$destination_cidr" != "$cidr_block" ] && [ "$destination_cidr" != "0.0.0.0/0" ]; then
        echo "Deletando rota para $destination_cidr"
        aws ec2 delete-route \
            --region $REGION \
            --route-table-id $route_table_id \
            --destination-cidr-block $destination_cidr
    fi
done

sleep 10

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