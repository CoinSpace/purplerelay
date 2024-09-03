#!/usr/bin/env sh
# set -eo pipefail

mkdir -p /etc/nginx/sites-enabled
mkdir -p /etc/nginx/sites-available

cp -r ./nginx.conf /etc/nginx/nginx.conf
cp -r ./default.conf /etc/nginx/sites-enabled/default.conf

ln -s /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default

chmod +x ./config-policy.sh
chmod +x ./config-strfry-router.sh
./config-policy.sh
./config-strfry-router.sh

adduser -S www-data

nginx
./strfry sync wss://purplerelay.com --dir both
./strfry relay