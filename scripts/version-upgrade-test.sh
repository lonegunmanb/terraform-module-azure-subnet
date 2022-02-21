#!/usr/bin/env bash

echo "==> Version upgrade test..."

latest_tag=$(curl -s 'https://api.github.com/repos/lonegunmanb/terraform-module-azure-subnet/tags' | jq -r '[.[] | select(.name | index("rc") | not) | .name][0]')

git clone https://github.com/lonegunmanb/terraform-module-azure-subnet.git /tmp/latest_tag
cd /tmp/latest_tag
ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts
git fetch --all --tags
git checkout $latest_tag
chmod -R o+x /tmp/latest_tag
MODULE_SOURCE=/tmp/latest_tag make e2e-test