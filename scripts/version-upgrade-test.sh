#!/usr/bin/env bash

function runTests {
  echo "==> Running Module Version Upgrade Tests..."
  (cd ./test/upgrade && go mod tidy && go test -v -p=1 -timeout=120m ./...) || exit 1
}

function main {
  runTests
}

main
