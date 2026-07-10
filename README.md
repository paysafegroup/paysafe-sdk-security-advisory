# Security Advisory: Fake Paysafe, Skrill and Neteller SDK Packages on npm and PyPI

**Date:** 9 July 2026  
**Audience:** Paysafe, Skrill and Neteller merchants, developers, platform partners, and integration teams  
**Severity:** Action required for merchants who may have installed the listed packages

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

This repository provides ready-to-use detection scripts that implement the checks described below.

Repository structure:

```
scripts/
├── check-npm-packages.sh
├── check-python-packages.py
├── check-lockfiles.sh
└── check-python-lockfiles.sh
```

---



## Detecting Fake npm Packages

Run the following from the root of each JavaScript or TypeScript project, including application repositories, shared libraries, deployment tooling, and CI build images.

```bash
chmod +x scripts/check-npm-packages.sh

./scripts/check-npm-packages.sh
```

The script checks for all publicly reported malicious npm package names within the project's dependency tree.

If your organization uses monorepos or workspaces, execute the script from the repository root and within any package directories that manage dependencies independently.

---



## Detecting Fake Python Packages

Run the Python detection script inside every Python virtual environment, container image, CI image and development environment used to build or deploy your integration.

```bash
python scripts/check-python-packages.py
```

The script checks installed Python packages for the publicly reported malicious package names.

---



## Checking Lockfiles and Dependency Manifests

The repository also provides helper scripts for scanning dependency manifests and lockfiles without installing dependencies.

### npm

```bash
chmod +x scripts/check-lockfiles.sh

./scripts/check-lockfiles.sh
```

The script scans:

- package.json
- package-lock.json
- npm-shrinkwrap.json
- yarn.lock
- pnpm-lock.yaml



### Python

```bash
chmod +x scripts/check-python-lockfiles.sh

./scripts/check-python-lockfiles.sh
```

The script scans:

- requirements*.txt
- pyproject.toml
- poetry.lock
- Pipfile
- Pipfile.lock
- setup.py
- setup.cfg

If your project uses multiple repositories, workspaces or monorepos, run the relevant script from each repository root.

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
merchant-security-tools/
│
├── README.md
│
└── scripts/
    ├── check-npm-packages.sh
    ├── check-python-packages.py
    ├── check-lockfiles.sh
    └── check-python-lockfiles.sh
```

The scripts in this repository are **read-only detection utilities**. They perform local dependency checks and do not upload project information or communicate with external services.

---



# Disclaimer

This repository contains detection utilities for the package names publicly reported as malicious at the time this advisory was published.

These scripts are intended to assist merchants in identifying potential exposure and should be used alongside existing endpoint protection, software composition analysis (SCA), dependency scanning and incident response processes.