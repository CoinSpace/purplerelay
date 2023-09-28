#!/usr/bin/env sh
set -eo pipefail

wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz && \
tar xzf google-cloud-sdk.tar.gz -C / && \
/google-cloud-sdk/install.sh --usage-reporting false --path-update false --quiet && \
rm google-cloud-sdk.tar.gz

export PATH=/google-cloud-sdk/bin:${PATH}
