#!/bin/bash

INSTANCE_NAME_FILTER=purplerelay-cluster
ORIGINAL_FILE=./strfry-policy-base.ts
NEW_FILE=./strfry-policy.ts

# Função para obter todas as regiões disponíveis
get_regions() {
  aws ec2 describe-regions --query "Regions[].RegionName" --output text
}

get_private_ips_in_region() {
  local region=$1
  local instance_name_filter=$2
  aws ec2 describe-instances --region "$region" \
    --filters "Name=tag:Name,Values=$instance_name_filter" \
    --query "Reservations[*].Instances[*].NetworkInterfaces[*].PrivateIpAddresses[*].PrivateIpAddress" \
    --output text
}

get_all_private_ips() {
  local regions=$(get_regions)
  local all_ips=()

  for region in $regions; do
    local ips=$(get_private_ips_in_region "$region" "$INSTANCE_NAME_FILTER")
    for ip in $ips; do
      all_ips+=("'$ip'")
    done
  done

  echo "$(IFS=,; echo "${all_ips[*]}")"
}

if [ -z "$INSTANCE_NAME_FILTER" ] || [ -z "$ORIGINAL_FILE" ] || [ -z "$NEW_FILE" ]; then
  echo "Por favor, forneça o nome da instância, o arquivo original e o novo arquivo como argumentos."
  exit 1
fi

WHITELIST=$(get_all_private_ips)

sed "s/##REPLACE_WHITELIST##/$WHITELIST/" "$ORIGINAL_FILE" > "$NEW_FILE"