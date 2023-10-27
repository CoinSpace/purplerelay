#!/usr/bin/env sh
set -eo pipefail

/google-cloud-sdk/bin/gcloud auth activate-service-account --key-file /root/.config/gcloud/application_default_credentials.json

/google-cloud-sdk/bin/gsutil cp gs://purple_caddy/purplerelay.com/dump.jsonl.zst /app/strfry-db/dump.jsonl.zst

zstd -d /app/strfry-db/dump.jsonl.zst
