# Security Advisory: Fake Paysafe, Skrill and Neteller SDK Packages on npm and PyPI

---

## Summary

Paysafe is aware of public reporting about fake SDK packages published to npm and PyPI using Paysafe, Skrill and Neteller-related names. According to the report, these packages were malicious and were designed to steal credentials, access tokens and environment information from developer workstations and CI/CD environments.

There is **no indication** from the public report that Paysafe, Skrill, Neteller, or Paysafe-operated systems were breached. This advisory is intended to help merchants determine whether their own development, build or deployment environments may have been exposed through installation of malicious third-party packages.

Merchants should only install SDKs, libraries and integration components that are linked from the official Paysafe Developer documentation or published under verified Paysafe-owned package namespaces.

---



## Affected Fake Package Names

The following package names were publicly reported as malicious.

### npm

```
paysafe-checkout
paysafe-vault
neteller
skrill-payments
paysafe-js
paysafe-api
paysafe-node
paysafe-cards
paysafe-fraud
paysafe-kyc
skrill
skrill-sdk
paysafe-payments
```



### PyPI

```
paysafe-kyc
paysafe-payments
paysafe-sdk
paysafe-api
```

---



## Official Installation Guidance

Do **not** install Paysafe, Skrill or Neteller SDKs by searching public package registries and selecting packages based solely on their names.

Always install SDKs and integration libraries referenced from the official Paysafe Developer documentation:

> [https://developer.paysafe.com/](https://developer.paysafe.com/)

or from verified Paysafe-owned package namespaces referenced by the official documentation.

For React Native integrations, the official Paysafe Developer documentation installs packages from the `@paysafe/` npm namespace. Unscoped packages using Paysafe, Skrill or Neteller-related names should **not** be assumed to be official unless they are explicitly referenced by the Paysafe documentation.

---



# Detection

This repository provides a ready-to-use detection script that checks for the reported malicious package names.

Repository structure:

```
scripts/
└── check-all.sh
```

---



## Recommended Fix

Run the combined script from the root of each project, monorepo package, or CI workspace you want to scan. It performs all four checks in one step:

- installed npm packages
- npm lockfiles and manifests
- installed Python packages
- Python lockfiles and manifests

```bash
chmod +x scripts/check-all.sh

./scripts/check-all.sh
```

The script performs all checks in one step:

- **Installed npm packages** — checks the project's dependency tree for all reported malicious npm package names
- **npm lockfiles and manifests** — scans `package.json`, `package-lock.json`, `npm-shrinkwrap.json`, `yarn.lock`, and `pnpm-lock.yaml`
- **Installed Python packages** — checks the active Python environment for all reported malicious PyPI package names
- **Python lockfiles and manifests** — scans `requirements*.txt`, `pyproject.toml`, `poetry.lock`, `Pipfile`, `Pipfile.lock`, `setup.py`, and `setup.cfg`

The script exits with code `1` if any reported package name is found, and `0` if none are detected. It skips checks when the relevant tool or files are not present (for example, if npm or Python is not installed).

If your organization uses monorepos or workspaces, run the script from each repository root and within any package directories that manage dependencies independently. For Python projects, run the script inside every virtual environment, container image, CI image, and development environment used to build or deploy your integration.

---



# Immediate Actions if a Package is Detected

If any of the reported package names are detected within your development, build or deployment environments:

1. Remove the package

**For npm**

```bash
npm uninstall paysafe-checkout paysafe-vault neteller skrill-payments paysafe-js paysafe-api paysafe-node paysafe-cards paysafe-fraud paysafe-kyc skrill skrill-sdk paysafe-payments
```

**For Python**

```bash
python -m pip uninstall paysafe-kyc paysafe-payments paysafe-sdk paysafe-api
```

1. Stop using the affected environment immediately. Treat any workstation, container image, CI runner or build environment that executed the package as potentially exposed.
2. Rotate Paysafe, Skrill and Neteller API credentials that were available within the affected environment.
3. Rotate any other potentially exposed secrets, including:
  - GitHub tokens
  - Cloud credentials
  - CI/CD secrets
  - npm tokens
  - PyPI tokens
  - SSH keys
  - Deployment credentials
  - Webhook secrets
  - Database credentials
4. Review CI/CD logs and build output for:
  - installation of the affected package
  - API key exposure
  - environment variable output
  - unexpected outbound network activity
  - failed installation attempts
5. Review repository history and dependency changes to determine:
  - when the package was introduced
  - who approved the dependency
  - which builds included the package
6. Rebuild affected environments from a known-clean source.
  Do not simply uninstall the package and continue using the same workstation, container image or virtual environment.
7. Monitor API usage and account activity for unexpected authentication attempts, unusual API requests or configuration changes.

---



# Recommended Safe Integration Practices

To reduce the risk of dependency confusion, typosquatting, or malicious package installation:

- **Use official Paysafe documentation as the source of truth.** Install only the packages, SDKs and scripts linked from official Paysafe Developer documentation.
- **Pin and review dependencies.** Use lockfiles such as package-lock.json, pnpm-lock.yaml, yarn.lock, poetry.lock or equivalent, and review dependency changes before merging.
- **Use a private registry or dependency proxy.** Mirror approved packages and block known-bad package names at the registry/proxy level.
- **Do not expose live secrets during dependency installation.** Package install steps should not run with production Paysafe credentials, cloud credentials, GitHub tokens, npm tokens, PyPI tokens, or broad CI secrets available in the environment.
- **Use scoped, least-privilege API keys.** Use separate keys for development, test, staging and production. Avoid sharing one credential across multiple environments or services.
- **Restrict credential usage where available.** Apply IP allow-listing, domain restrictions, environment restrictions, and role-based access controls where supported.
- **Require dependency review for payment integrations.** Treat new SDKs, payment packages, build plugins, and post-install scripts as high-risk changes requiring review.
- **Disable or control install scripts where practical.** For npm, consider using `--ignore-scripts` in CI where your build process allows it, or explicitly allow only required install scripts.
- **Scan dependency trees regularly.** Include direct and transitive dependency checks in CI and software composition analysis tooling.
- **Keep secrets out of repositories and logs.** Use a secret manager, avoid printing environment variables in CI, and enable secret scanning for repositories and build logs.

---



# Support

If you believe your environment may have installed one of the reported packages, contact Paysafe through your usual merchant support channel, account manager or the Paysafe Business Experience Support Portal.

When contacting support, include:

```
Merchant name:

Paysafe Account ID (if available):

Affected environment:
(Local / CI / Staging / Production)

Package manager:
(npm / PyPI / Both)

Package name and version detected:

Date first installed (if known):

Whether live credentials were present:

Whether credentials have been rotated:

Summary of remediation actions already completed:
```

**Do not include API keys, passwords, access tokens, private keys or customer payment data in support requests.**

---



# Repository Contents

```
paysafe-sdk-security-advisory/
│
├── README.md
│
└── scripts/
    └── check-all.sh
```

The script in this repository is a **read-only detection utility**. It performs local dependency checks and does not upload project information or communicate with external services.

---



# Disclaimer

This repository contains a detection utility for the package names publicly reported as malicious at the time this advisory was published.

This script is intended to assist merchants in identifying potential exposure and should be used alongside existing endpoint protection, software composition analysis (SCA), dependency scanning and incident response processes.
