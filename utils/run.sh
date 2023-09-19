#!/usr/bin/env bash
set -eo pipefail

# Create mount directory for service
mkdir -p $MNT_DIR

cp -r ./nginx.conf /etc/nginx/nginx.conf
cp -r ./new.default.conf /etc/nginx/sites-enabled/default.conf

echo "Mounting GCS Fuse."
gcsfuse --debug_gcs --debug_fuse $BUCKET $MNT_DIR
echo "Mounting completed."

# Start the application
nginx
./strfry relay
# Exit immediately when one of the background processes terminate.
wait -n
# [END cloudrun_fuse_script]