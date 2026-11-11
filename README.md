# Fenrir Platform

Fenrir is a self-hosted platform for managed service providers. It brings endpoint security, remote monitoring and
management (RMM), Microsoft 365 administration, vulnerability management and day-to-day MSP operations together in one
place, with no per-device licence fees.

> **This repository is a fixed snapshot.** It shows the platform as it runs in production and doesn't accept changes.
> To build on it, click **Use this template** (or fork it) and make the copy your own.
>
> Fenrir is free, provided **as is**, with **no warranty and no support**. See [Licence](#licence).

## What it does

| Area | What's included |
|---|---|
| Endpoint security | Windows, macOS, Linux and Android agents; detection rules and a malware model; alerts, incidents, quarantine and response; DNS and web protection; free threat feeds (abuse.ch, IPsum). |
| RMM | Inventory, monitoring, scripts and a categorised script library, patching, software deployment, terminal, files, and browser-based remote control (direct peer-to-peer, with a relay fallback). |
| Microsoft 365 | Every customer tenant in one view: users, MFA, groups, guests, sign-in and audit logs, onboarding and offboarding, Exchange, Teams, SharePoint, Intune, security standards and scheduled reports. |
| Exposure | Vulnerability inventory with CVE, EPSS and KEV data, device risk scores and remediation tracking. |
| MSP operations | Customers, tickets, time, projects, CRM, quotes, agreements, billing and a client portal. |
| Governance | UK governance frameworks, policies, evidence, risks, a credential vault, network monitoring and backup status. |

A deployment is **PostgreSQL** plus the **Fenrir server**, which also serves the web console, the agent downloads and
remote sessions. **Caddy** in front provides HTTPS.

## What's in this repository

| Folder | Contents |
|---|---|
| [`cloud/`](cloud) | The server (Python, FastAPI) and its tests. |
| [`console/`](console) | The web console (React, TypeScript). |
| [`agent/`](agent) | The endpoint agents: [Windows](agent/windows) (C++), [Linux and macOS](agent/linux) (Go), [Android](agent/android) (Kotlin). |
| [`catalogue/`](catalogue) | The built-in app catalogue and script library, with a signed manifest. |
| [`ml/`](ml) | The static malware model and the code that trains it. |
| [`deploy/`](deploy) | The Dockerfile, Compose files, one-command installer, backup, restore, updates, signing and the read-only [demo](deploy/demo). |
| [`docs/`](docs) | Guides for the parts of the platform listed below. |
| [`third_party/`](third_party) | Bundled third-party source (SQLite). |

## Install

You need a Linux server (Ubuntu or Debian, 2 GB of memory, 15 GB of free disk) and a DNS record pointing your hostname
at it. Then run:

```bash
git clone <your copy's URL> /opt/fenrir && cd /opt/fenrir
sudo deploy/install.sh --domain rmm.example.com --email you@example.com --company "Your Company"
```

This takes about 10–15 minutes. It installs Docker, creates new secrets and your own free code-signing certificate, sets
up HTTPS with Let's Encrypt, builds and starts the server, schedules backups and updates, and runs the go-live check. At
the end it prints the console address and the first sign-in.

To try it on your own machine without HTTPS or a signing certificate, copy `deploy/.env.example` to `deploy/.env`,
fill in the secrets, set `FENRIR_PUBLIC_URL=http://localhost:8080` and `FENRIR_BUILD_PROFILE=lab`, then:

```bash
docker compose -f deploy/docker-compose.yml -f deploy/docker-compose.lab.yml \
  -f deploy/docker-compose.local.yml --env-file deploy/.env up -d --build
```

The console is then at `http://localhost:8080`. Windows installers built this way are unsigned and only for testing.

## Guides

- **Running it:** [go-live checklist](docs/GO_LIVE.md), [code signing](docs/CODE_SIGNING.md),
  [updates](docs/AUTO_UPDATE.md), [backup and restore](docs/BACKUP_AND_RESTORE.md).
- **Agents:** [deploy from your RMM, Group Policy or Intune](docs/DEPLOY_FROM_YOUR_RMM.md),
  [installing on macOS](docs/MACOS_INSTALL.md), [iPhone and iPad web protection](docs/APPLE_WEB_PROTECTION.md),
  [Windows agent persistence](docs/WINDOWS_AGENT_PERSISTENCE.md), [Windows patching](docs/WINDOWS_PATCHING.md).
- **How it works:** [architecture](docs/ARCHITECTURE.md), [remote protocol](docs/REMOTE_PROTOCOL.md),
  [zero-trust remote administration](docs/ZERO_TRUST_REMOTE_ADMINISTRATION.md), [RMM and PSA](docs/RMM_PSA.md),
  [governance](docs/GOVERNANCE.md), [Microsoft 365 scope](docs/M365_ADMINISTRATION_SCOPE.md),
  [reports and branding](docs/REPORTS_AND_BRANDING.md), [app and script catalogue](catalogue/README.md),
  [malware model](ml/README.md).

## Limits

- Windows protection runs in user mode. The kernel driver and pre-execution blocking are not included.
- Code that exists here is not proof that a feature has been independently tested on real devices. Test it on your
  own systems before you rely on it.
- Hosting, a domain, publicly trusted code signing and some optional providers can still cost money.

## Licence

Fenrir is licensed under the [Apache License 2.0](LICENSE). Third-party notices are in [NOTICE](NOTICE).

- **No warranty.** The software is provided "AS IS", without warranties of any kind (sections 7 and 8 of the licence).
  That includes anything done by scripts, patches, remote actions, policies or Microsoft 365 changes you run through it.
- **No support.** There is no maintenance, support or response commitment.
- **Your installation, your responsibility.** An RMM controls every device it manages. Keep the server patched and
  behind HTTPS, use MFA on every console account, protect the signing and vault keys, and test changes on a few devices
  first.
- **Security problems:** see [SECURITY.md](SECURITY.md).
