#!/usr/bin/env bash
set -euo pipefail

# Combined detection script for the Paysafe SDK security advisory.
# Run from the root of each project, monorepo package, or CI workspace you want to scan.

NPM_PKGS=(
  paysafe-checkout paysafe-vault neteller skrill-payments paysafe-js
  paysafe-api paysafe-node paysafe-cards paysafe-fraud paysafe-kyc
  skrill skrill-sdk paysafe-payments
)

PYPI_PKGS=(paysafe-kyc paysafe-payments paysafe-sdk paysafe-api)

NPM_PATTERN='"(paysafe-checkout|paysafe-vault|neteller|skrill-payments|paysafe-js|paysafe-api|paysafe-node|paysafe-cards|paysafe-fraud|paysafe-kyc|skrill|skrill-sdk|paysafe-payments)"'
PYPI_PATTERN='(^|[=<>~! ]|\b)(paysafe-kyc|paysafe-payments|paysafe-sdk|paysafe-api)(\b|[=<>~! ])'

FOUND=0

section() {
  echo
  echo "=== $1 ==="
}

found() {
  FOUND=1
  echo "FOUND: $*"
}

echo "Paysafe Security Advisory - Combined Dependency Check"
echo "Scanning: $(pwd)"

# --- 1. Installed npm packages ---
section "Installed npm packages"
if command -v npm >/dev/null 2>&1; then
  npm_found=0
  for p in "${NPM_PKGS[@]}"; do
    if npm ls "$p" --all >/dev/null 2>&1; then
      found "$p"
      npm_found=1
    fi
  done
  [ "$npm_found" -eq 0 ] && echo "No reported npm packages detected."
else
  echo "Skipped: npm not found."
fi

# --- 2. npm lockfiles and manifests ---
section "npm lockfiles and manifests"
npm_files=(package.json package-lock.json npm-shrinkwrap.json yarn.lock pnpm-lock.yaml)
npm_scan=()
for f in "${npm_files[@]}"; do
  [ -e "$f" ] && npm_scan+=("$f")
done

if [ "${#npm_scan[@]}" -gt 0 ]; then
  if grep -RInE "$NPM_PATTERN" "${npm_scan[@]}" 2>/dev/null; then
    FOUND=1
  else
    echo "No reported package names found."
  fi
else
  echo "Skipped: no npm manifest or lockfiles found."
fi

# --- 3. Installed Python packages ---
section "Installed Python packages"
PY=""
for candidate in python3 python; do
  if command -v "$candidate" >/dev/null 2>&1; then
    PY="$candidate"
    break
  fi
done

if [ -n "$PY" ] && "$PY" -m pip --version >/dev/null 2>&1; then
  py_found=0
  installed=$("$PY" -m pip list --format=columns 2>/dev/null || true)
  for p in "${PYPI_PKGS[@]}"; do
    if echo "$installed" | grep -qiE "^${p}[[:space:]]"; then
      version=$(echo "$installed" | grep -iE "^${p}[[:space:]]" | awk '{print $2}')
      found "$p ${version:-unknown}"
      py_found=1
    fi
  done
  [ "$py_found" -eq 0 ] && echo "No reported PyPI packages detected."
else
  echo "Skipped: Python or pip not found."
fi

# --- 4. Python lockfiles and manifests ---
section "Python lockfiles and manifests"
py_files=()
for pattern in requirements*.txt pyproject.toml poetry.lock Pipfile Pipfile.lock setup.py setup.cfg; do
  for f in $pattern; do
    [ -e "$f" ] && py_files+=("$f")
  done
done

if [ "${#py_files[@]}" -gt 0 ]; then
  if grep -RInE "$PYPI_PATTERN" "${py_files[@]}" 2>/dev/null; then
    FOUND=1
  else
    echo "No reported package names found."
  fi
else
  echo "Skipped: no Python manifest or lockfiles found."
fi

# --- Summary ---
section "Summary"
if [ "$FOUND" -eq 1 ]; then
  echo "ACTION REQUIRED: One or more reported malicious package names were detected."
  echo "See README.md for immediate remediation steps."
  exit 1
else
  echo "No reported malicious package names were detected."
  exit 0
fi
