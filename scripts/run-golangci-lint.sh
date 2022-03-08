#!/usr/bin/env bash

echo "==> Checking test go code against linters..."
cd ./test && go mod tidy && golangci-lint run --timeout 1h ./...
