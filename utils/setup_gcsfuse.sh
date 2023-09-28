#!/usr/bin/env sh
set -eo pipefail

wget https://go.dev/dl/go1.21.1.linux-amd64.tar.gz -O /tmp/go.tar.gz && \
tar -C /usr/local -xzf /tmp/go.tar.gz && \
rm /tmp/go.tar.gz

export PATH=$PATH:/usr/local/go/bin
export GOPATH=/go

go install github.com/googlecloudplatform/gcsfuse@latest
