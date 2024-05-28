#!/bin/bash

# set -x

############################################################################################################################################
### ============================== Configure PUBLIC HOSTED ZONE: Add CNAME record pointing region to LB ================================ ###
############################################################################################################################################

echo -e "================================== Configure PUBLIC HOSTED ZONE: Add CNAME record pointing region to LB \n"
# Get HZ ID based on input of HZ name.
PUBLIC_HOSTED_ZONE_NAME="$1"
PUBLIC_HOSTED_ZONE_ID="$(aws route53 list-hosted-zones --query "HostedZones[?Name=='$PUBLIC_HOSTED_ZONE_NAME.'].Id" --output text)"
if [ -z "$PUBLIC_HOSTED_ZONE_ID" ]; then
    echo "Error: Please provide a valid NAME of PUBLIC HOSTED ZONE as the first argument."
    exit 1
fi

# Declarations of every region and its records to be created or updated.
declare -A region1=(
    ["name"]="us-east-2"
    ["record_subdomain[0]"]="ca"
    ["record_subdomain[1]"]="us"
    ["record_subdomain[2]"]="us2"
)
declare -A region2=(
    ["name"]="af-south-1"
    ["record_subdomain[0]"]="af"
    ["record_subdomain[1]"]="za"
)
declare -A region3=(
    ["name"]="ap-northeast-1"
    ["record_subdomain[0]"]="au"
    ["record_subdomain[1]"]="hk"
    ["record_subdomain[2]"]="jp"
    ["record_subdomain[3]"]="kr"
    ["record_subdomain[4]"]="tw"
)
declare -A region4=(
    ["name"]="eu-central-1"
    ["record_subdomain[0]"]="ae"
    ["record_subdomain[1]"]="ch"
    ["record_subdomain[2]"]="de"
    ["record_subdomain[3]"]="eu"
    ["record_subdomain[4]"]="fl"
    ["record_subdomain[5]"]="il"
    ["record_subdomain[6]"]="in"
    ["record_subdomain[7]"]="ir"
    ["record_subdomain[8]"]="me"
    ["record_subdomain[9]"]="pl"
    ["record_subdomain[10]"]="qa"
    ["record_subdomain[11]"]="uk"
)
declare -A region5=(
    ["name"]="sa-east-1"
    ["record_subdomain[0]"]="br"
    ["record_subdomain[1]"]="cl"
)

# For each region, create or update its records, pointing to the region's LB.
declare -n region
for region in ${!region@}; do
    LOAD_BALANCER_DNS="$(aws elbv2 describe-load-balancers --region ${region[name]}  --query "LoadBalancers[*].DNSName" --output text)"
    echo "--------------------- Region: ${region[name]}"
    echo -e "--------------------- LB DNS: $LOAD_BALANCER_DNS \n"
    for key in "${!region[@]}"; do
            if [[ $key == record_subdomain* ]]; then
                SUBDOMAIN=${region[$key]}
                echo "Subdomain to be created or updated in ${region[name]}: $SUBDOMAIN"
                aws route53 change-resource-record-sets --hosted-zone-id $PUBLIC_HOSTED_ZONE_ID --change-batch '{"Changes": [ { "Action": "UPSERT", "ResourceRecordSet": { "Name": "'"$SUBDOMAIN.$PUBLIC_HOSTED_ZONE_NAME"'", "Type": "CNAME", "TTL": 3600, "ResourceRecords": [{ "Value": "'"$LOAD_BALANCER_DNS"'" }] } } ]}'
                echo -e "\n\n"
            fi
    done
done



############################################################################################################################################
### ============================== Configure PRIVATE HOSTED ZONES: Associate VPCs with Private HZs ===================================== ###
############################################################################################################################################

echo -e "\n================================== Configure PRIVATE HOSTED ZONES: Associate VPCs with Private HZs \n"
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
