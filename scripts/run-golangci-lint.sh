#!/usr/bin/env bash

function runLinters {
  echo "==> Checking test go code against linters..."
  (cd ./test/e2e && golangci-lint run -v ./...)
}

function main {
  runLinters
}

main
