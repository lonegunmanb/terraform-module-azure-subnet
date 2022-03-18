#!/usr/bin/env bash

echo "==> Running Module Version Upgrade Tests..."
set -e
cd ./test/upgrade
go mod tidy
echo "==> Executing go test"
go test -v -p=1 -timeout=120m ./...