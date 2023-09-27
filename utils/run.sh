#!/usr/bin/env sh
set -eo pipefail

mkdir /etc/nginx/sites-available
mkdir /etc/nginx/sites-enabled

cp -r ./nginx.conf /etc/nginx/nginx.conf
cp -r ./new.default.conf /etc/nginx/sites-enabled/default.conf

# ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled

go install github.com/googlecloudplatform/gcsfuse@latest

echo "Mounting GCS Fuse."
/go/bin/gcsfuse --debug_gcs --debug_fuse $BUCKET $MNT_DIR
echo "Mounting completed."

adduser -s /bin/false nginx

# Start the application
nginx
./strfry relay
# Exit immediately when one of the background processes terminate.
wait -n
# [END cloudrun_fuse_script]