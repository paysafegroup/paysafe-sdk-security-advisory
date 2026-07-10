#!/usr/bin/env bash
grep -RInE '(^|[=<>~! ]|\b)(paysafe-kyc|paysafe-payments|paysafe-sdk|paysafe-api)(\b|[=<>~! ])' \
 requirements*.txt pyproject.toml poetry.lock Pipfile Pipfile.lock setup.py setup.cfg 2>/dev/null \
 || echo "No reported package names found."
