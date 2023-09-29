#!/usr/bin/env sh
set -eo pipefail

/google-cloud-sdk/bin/gsutil cp gs://purple_caddy/purplerelay.com/dump.jsonl.zst ./dump.json.zst

./strfry import < ./dump.jsonl.zst