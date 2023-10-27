#!/bin/bash

subdomains=("au" "br" "ca" "ch" "fl" "hk" "il" "in" "jp" "kr" "pl" "qa" "uk" "tw" "cl")

ip_addresses=("Insert IP Address here")

HOSTED_ZONE_ID="Z1025834OGZMTRNN5L66"

for i in "${!subdomains[@]}"; do
  subdomain="${subdomains[i]}"
  full_name="${subdomain}.purplerelay.com"
  ip_address="${ip_addresses[i]}"

  aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch '{
    "Changes": [
      {
        "Action": "CREATE",
        "ResourceRecordSet": {
          "Name": "'"$full_name"'",
          "Type": "A",
          "TTL": 300,
          "ResourceRecords": [
            {
              "Value": "'"$ip_address"'"
            }
          ]
        }
      }
    ]
  }'
done
