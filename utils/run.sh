#!/usr/bin/env sh
set -eo pipefail

mkdir -p /etc/nginx/sites-enabled
mkdir -p /etc/nginx/sites-available

cp -r ./nginx.conf /etc/nginx/nginx.conf
cp -r ./new.default.conf /etc/nginx/sites-enabled/default.conf

ln -s /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default

echo "Mounting GCS Fuse."
/go/bin/gcsfuse --debug_gcs --debug_fuse $BUCKET $MNT_DIR
echo "Mounting completed."

adduser -S www-data

nginx
./strfry relay
wait -n
# [END cloudrun_fuse_script]

./strfry import < /app/dump.jsonl --no-verify

rm /app/dump.jsonl