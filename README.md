# DevOps Project

## Project Description

This repository is a complete end-to-end DevOps learning project built around a small Python Flask
application. The goal is to gradually build a realistic production-like environment that includes:

- containerization with Docker
- CI/CD pipelines (GitHub Actions)
- artifact registries (Docker Registry & GitHub Packages)
- infrastructure provisioning (Terraform)
- configuration management (Ansible roles)
- monitoring and visualization (Prometheus & Grafana)
- security best practices (jump host, SSH hardening, TLS certificates)

The project grows in clear stages. Each stage is documented with **what was done**, **why it matters**,
and **how it was implemented**, so it becomes both a learning journal and a portfolio project.

## Structure

Current project layout:

```
cloud_devops_lab/
├── ansible
│   ├── ansible.cfg
│   ├── group_vars
│   │   └── all.yml
│   ├── hosts.ini
│   ├── playbooks
│   │   └── bootstrap.yml
│   ├── README.md
│   └── roles
│       ├── bootstrap_users
│       ├── common
│       └── ssh_hardening
├── app
│   ├── Dockerfile
│   ├── requirements.txt
│   ├── src
│   │   ├── app.py
│   │   ├── __init__.py
│   │   ├── __pycache__
│   │   ├── routes
│   │   └── utils
│   └── venv
│       ├── bin
│       ├── include
│       ├── lib
│       ├── lib64 -> lib
│       └── pyvenv.cfg
├── infrastructure
│   └── terraform
│       ├── main.tf
│       ├── modules
│       ├── outputs.tf
│       ├── providers.tf
│       ├── terraform.tfstate
│       ├── terraform.tfstate.backup
│       ├── terraform.tfvars
│       └── variables.tf
├── LICENSE
└── README.md
```

## Requirements (current)

- Python 3.12+
- pip / venv
- Git
- Ansible
- Terraform
- Linode for server hosting
- Cloudflare (DNS)
- Domain registrar

## Running the Application Locally

```
python -m venv venv
source venv/bin/activate
pip install -r app/requirements.txt
python -m app.src.app
```

```
Application runs at:
http://localhost:5000/
```

## Stages

The project is built in incremental stages. Each stage adds a new DevOps capability on top of the existing system.

### Upcoming Stages

### Upcoming Stages

- <s>Stage 2: Containerization with Docker</s>
- <s>Stage 3: CI/CD pipeline (GitHub Actions)</s>
- <s>Stage 4: Infrastructure (Terraform – servers, networking, firewalls)</s>
- <s>Stage 5: DNS & domain management (Cloudflare)</s>
- Stage 6: Ansible configuration (roles, hardening, deployments)
- Stage 7: Monitoring stack (Prometheus & Grafana)
- Stage 8: TLS certificates & reverse proxy
- Stage 9: Security improvements & hardening

### Stage 1 — Flask Application

**What:** Implemented a minimal Flask API with initial routing.  
**Why:** A simple application is required before adding Docker, CI/CD, infrastructure and monitoring.  
**How:** Created project folder structure, used Blueprints, tested locally with Python.

- Basic Flask application runs locally.
- Endpoints:
  - `/` – root
  - `/health`
- Foundation for Dockerization, CI/CD, monitoring and future infrastructure work.

### Stage 2 — Containerization with Docker

**What:**  
Created a production-ready Dockerfile for the Flask application using a multi-stage build.

**Why:**  
Containerizing the application allows consistent deployment across environments and provides the
foundation for CI/CD pipelines, registries, deployment automation, and infrastructure scaling.

**How:**

- Implemented a two-stage Dockerfile (builder + runtime).
- Installed dependencies in an isolated build layer.
- Copied only necessary runtime dependencies into a slim final image.
- Added a non-root application user for security.
- Added a Docker HEALTHCHECK hitting `/health`.
- Exposed port 5000 and used Gunicorn as the production WSGI(Web Server Gateway Interface) server.
- Built and ran the image locally to verify functionality.

**How to build and run**

1. Build image: `docker build -t cloud-devops-app:0.1 .`
2. Run container: `docker run -p 5000:5000 cloud-devops-app:0.1`
3. Test health endpoint: `curl http://localhost:5000/health`
4. Test metrics: `curl http://localhost:5000/metrics/custom`

### Stage 3 — CI/CD Pipeline (GHCR Integration)

**What:**  
Extended the GitHub Actions workflow to build Docker images with tags and push them to
GitHub Container Registry (GHCR).

**Why:**  
A registry is required for deployment automation and ensures versioned, reproducible artifacts
that can be pulled by servers during deployment.

**How:**

- Added permissions for GitHub Actions to write to GHCR.
- Logged in to GHCR using `GITHUB_TOKEN`.
- Created two image tags (`latest` and short commit SHA).
- Pushed images automatically on changes to `develop` and `main`.

### Stage 4 - Infrastructure (Terraform – servers, networking, firewalls)

Infrastructure is provisioned using Terraform on Linode (Akamai).

#### Architecture Overview

- **Jump Server**
  - Public + private IP
  - SSH entry point (bastion host)

- **Application Server**
  - Private network only
  - Runs application containers

- **Monitoring Server**
  - Private network only
  - Runs Prometheus and Grafana

All servers share a private network.  
Only the jump server is reachable from the public internet.

#### Security Model

- Bastion (jump server) pattern
- SSH key authentication only
- No private keys stored on servers
- App and monitoring servers accessible only via private network
- Network access enforced using Linode Firewalls
- SSH agent forwarding used for hop-based access

#### Terraform Structure

```
infrastructure
└── terraform
    ├── main.tf
    ├── modules
    │   └── compute
    │       ├── main.tf
    │       ├── outputs.tf
    │       ├── providers.tf
    │       └── variables.tf
    ├── outputs.tf
    ├── providers.tf
    └── variables.tf
```

This stage establishes the baseline infrastructure but does not yet deploy applications.

### Stage 5 - DNS & Domain Management

The domain `clouddevopslab.eu` is registered at simply.com and delegated to Cloudflare
for DNS management and security features.

### Stage 6 — Ansible Bootstrap & Access Control

**What:**  
Introduced Ansible to centrally manage all servers using a bastion (jump host) model.
Bootstrapped a non-root `devops` user with SSH key access and sudo privileges.

**Why:**  
Manual server configuration does not scale and is error-prone.
Ansible provides reproducible, auditable configuration management and enforces
least-privilege access by avoiding root logins.

**How:**  
- Configured Ansible inventory with a jump host (bastion pattern).
- Enabled SSH agent forwarding for secure multi-hop access.
- Created a reusable `common` role for connectivity checks.
- Added a `bootstrap_users` role to:
  - create a `devops` user
  - configure passwordless sudo
  - install SSH public keys
- Switched Ansible to run as `devops` with privilege escalation (`become`).

### Access Model

- Direct SSH access is allowed only to the jump server.
- All internal servers are accessed via the jump server using SSH agent forwarding.
- Ansible connects as a non-root `devops` user and escalates privileges only when required.
- Root login remains enabled temporarily and will be disabled in a later hardening stage.

#### DNS Flow

- Domain registered at simply.com
- Nameservers delegated to Cloudflare
- DNS records managed in Cloudflare
- Application traffic will later be proxied via Cloudflare

#### Current Records

- `clouddevopslab.eu` → A record → application server
- `www.clouddevopslab.eu` → A record → application server

At this stage, DNS records exist but application traffic is not yet exposed.

Note: During early stages, application IP addresses may change when infrastructure
is recreated. A reserved IPv4 address will be introduced later to provide a stable
DNS target.

## Learning Log

A chronological log describing the work done in each stage.

## Next Step

- <s>Proceed to Stage 2: Containerization With Docker, Where The Application Will Be Packaged Into A Production-Ready Container Image.</s>
- <s>Procced to Stage 3: CI/CD pipeline (GitHub Actions & GHCR Integration)</s>
- <s>Procced to Stage 4: Infrastructure (Terraform – servers, networking, firewalls)</s>
- <s>Procced to Stage 5: DNS & domain management (Cloudflare)</s>
- Procced to Stage 6: Ansible configuration (roles, hardening, deployments)

## Git Workflow & Conventions

This repository uses a simple branching and commit strategy to keep the history clean and understandable.

### Branches

- `main`  
  Always deployable and represents the most stable state. Release tags will be created from this branch.

- `develop`  
  Integration branch for day-to-day work. Features, fixes and infrastructure changes are merged here before going to `main`.

- Short-lived branches  
  All work is done on short-lived branches and merged via pull requests:
  - `feature/<short-description>` – new functionality
  - `fix/<short-description>` – bug fixes
  - `infra/<short-description>` – infrastructure (Terraform, Ansible, etc.)
  - `docs/<short-description>` – documentation updates
  - `ci/<short-description>` – CI/CD pipeline changes

  Examples:
  - `feature/add-metrics-endpoint`
  - `infra/add-terraform-app-server`
  - `docs/update-readme-git-strategy`
  - `ci/add-docker-build-workflow`

### Commit Messages

Commit messages follow a light version of Conventional Commits:

`<type>(<optional-scope>): <short summary>`

Types used in this project:

- `feat` – new features (app or infra)
- `fix` – bug fixes
- `docs` – documentation changes
- `infra` – infrastructure code changes
- `ci` – CI/CD configuration
- `refactor` – code changes that don’t change behaviour
- `chore` – maintenance tasks, formatting, small cleanups

Examples:

- `feat(api): add /metrics/custom endpoint`
- `docs(readme): document phase 1 (Flask app)`
- `infra(terraform): create linode instances for app and monitoring`
- `ci(docker): add image build and push workflow`

## Infrastructure Changes

All infrastructure and configuration changes are performed via:
- Terraform (provisioning)
- Ansible (configuration)

Manual changes on servers are avoided to ensure reproducibility.

## License

TBD – Will be added later in the project.
