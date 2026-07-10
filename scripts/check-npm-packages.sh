#!/usr/bin/env bash
set -euo pipefail
pkgs=(paysafe-checkout paysafe-vault neteller skrill-payments paysafe-js paysafe-api paysafe-node paysafe-cards paysafe-fraud paysafe-kyc skrill skrill-sdk paysafe-payments)
f=0
for p in "${pkgs[@]}"; do
 npm ls "$p" --all >/dev/null 2>&1 && echo "FOUND: $p" && f=1
done
[ $f -eq 0 ] && echo "No reported npm packages detected."
