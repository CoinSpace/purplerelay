#!/bin/bash

subdomains=("au" "br" "ca" "ch" "fl" "hk" "il" "in" "jp" "kr" "pl" "qa" "uk" "tw" "cl")

ip_addresses=("34.160.43.77" "35.244.207.133" "35.215.51.120" "34.149.59.79" "34.36.28.130" "34.149.114.254" "35.241.38.79" "34.111.100.209" "34.102.205.213" "34.149.241.138" "34.36.240.226" "34.111.104.43" "34.149.151.57" "34.36.81.106" "34.102.151.39" "34.120.190.215" "34.120.251.11" "34.107.144.207" "34.117.73.28" "34.36.14.162")

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
