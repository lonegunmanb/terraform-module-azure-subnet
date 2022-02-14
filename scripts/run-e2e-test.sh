#!/usr/bin/env bash

function runTests {
  echo "==> Running E2E Tests..."
  (cd ./test/e2e && go mod download -x && ./render_override.sh && go test -v -p=1 -timeout=120m ./...) || exit 1
}

function main {
  runTests
}

main
