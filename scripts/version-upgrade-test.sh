#!/usr/bin/env bash

echo "==> Running Module Version Upgrade Tests..."
set -e
cd ./test/upgrade
go mod tidy
go test -v -p=1 -timeout=120m ./...