#!/bin/bash

ORIGINAL_FILE=./strfry-router-base.config
NEW_FILE=./strfry-router.config

get_internal_hosted_zones() {
  aws route53 list-hosted-zones --query "HostedZones[?ends_with(Name, '.internal.')].Id" --output text
}

get_servicediscovery_records() {
  local zone_id=$1
  aws route53 list-resource-record-sets --hosted-zone-id "$zone_id" \
    --query "ResourceRecordSets[?starts_with(Name, 'servicediscovery-')].Name" --output text
}

get_all_servicediscovery_addresses() {
  local all_addresses=()
  local zones=$(get_internal_hosted_zones)

  for zone_id in $zones; do
    local records=$(get_servicediscovery_records "$zone_id")
    for record in $records; do
      formatted_address="wss://${record%?}"
      all_addresses+=("'$formatted_address'")
    done
  done

  echo "$(IFS=,; echo "${all_addresses[*]}")"
}

if [ -z "$ORIGINAL_FILE" ] || [ -z "$NEW_FILE" ]; then
  echo "Por favor, forneça o caminho do arquivo original e do novo arquivo."
  exit 1
fi

SERVICEDISCOVERY_ADDRESSES=$(get_all_servicediscovery_addresses)

sed "s|##REPLACE_WHITELIST##|$SERVICEDISCOVERY_ADDRESSES|" "$ORIGINAL_FILE" > "$NEW_FILE"