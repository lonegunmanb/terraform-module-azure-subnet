#!/usr/bin/env bash

function runLinters {
  echo "==> Checking test go code against linters..."
  (cd ./test && go mod tidy && golangci-lint run --timeout 1h ./...)
}

function main {
  runLinters
}

main
