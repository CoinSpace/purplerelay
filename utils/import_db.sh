#!/usr/bin/env sh
set -eo pipefail

/google-cloud-sdk/bin/gcloud auth activate-service-account --key-file /root/.config/gcloud/application_default_credentials.json

/google-cloud-sdk/bin/gsutil cp gs://purple_caddy/purplerelay.com/dump.jsonl.zst /app/dump.jsonl.zst

zstd -d /app/dump.jsonl.zst


rm /app/dump.jsonl.zst