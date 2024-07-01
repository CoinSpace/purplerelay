#!/bin/bash

# set -x
TAG_KEY='Name'
TAG_VALUE='purplerelay-VPC'
REGIONS=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)
HostedZoneIds=$(aws route53 list-hosted-zones --query "HostedZones[?Config.PrivateZone].Id" --output text | sed 's@/hostedzone/@@g')

list_vpcs_with_tag() {
    region=$1
    aws ec2 describe-vpcs --region $region \
        --filters "Name=tag-key,Values=$TAG_KEY" "Name=tag-value,Values=$TAG_VALUE" \
        --query "Vpcs[].VpcId" --output text
}

get_file() {

    for region in $REGIONS; do
        for HostedZoneId in $HostedZoneIds; do
            vpcs=$(list_vpcs_with_tag $region)
            if [ -n "$vpcs" ]; then
                aws route53 associate-vpc-with-hosted-zone --hosted-zone-id $HostedZoneId --vpc VPCRegion=$region,VPCId=$vpcs
            fi
        done
    done
}

get_file