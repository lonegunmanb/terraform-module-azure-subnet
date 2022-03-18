#!/usr/bin/env bash

echo "==> Running E2E Tests..."
set -e
cd ./test/e2e
go mod tidy
#sh ./render_override.sh
echo "==> go test"
go test -v -p=1 -timeout=120m ./...
