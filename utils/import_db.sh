#!/usr/bin/env sh
set -eo pipefail

export PATH=/google-cloud-sdk/bin:${PATH}

gsutil cp gs://purple_caddy/purplerelay.com/dump.jsonl.zst ./dump.json.zst