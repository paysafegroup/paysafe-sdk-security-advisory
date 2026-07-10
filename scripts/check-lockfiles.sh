#!/usr/bin/env bash
grep -RInE '"(paysafe-checkout|paysafe-vault|neteller|skrill-payments|paysafe-js|paysafe-api|paysafe-node|paysafe-cards|paysafe-fraud|paysafe-kyc|skrill|skrill-sdk|paysafe-payments)"' \
 package.json package-lock.json npm-shrinkwrap.json yarn.lock pnpm-lock.yaml 2>/dev/null \
 || echo "No reported package names found."