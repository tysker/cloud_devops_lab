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
├── app
│   ├── Dockerfile
│   ├── src
│   │   ├── app.py
│   │   ├── routes
│   │   └── utils
│   └── venv
├── infrastructure
│   └── terraform
│       ├── main.tf
│       ├── modules
│       │   └── compute
│       │       ├── main.tf
│       │       ├── outputs.tf
│       │       ├── providers.tf
│       │       └── variables.tf
│       ├── outputs.tf
│       ├── providers.tf
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
- Stage 5: DNS & domain management (Cloudflare)
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

## Learning Log

A chronological log describing the work done in each stage.

## Next Step

- <s>Proceed To Stage 2: Containerization With Docker, Where The Application Will Be Packaged Into A Production-Ready Container Image.</s>
- <s>Procced To Stage 3: CI/CD pipeline (GitHub Actions & GHCR Integration)</s>
- <s>Procced To Stage 4: Infrastructure (Terraform – servers, networking, firewalls)</s>
- Procced To Stage 5: DNS & domain management (Cloudflare)

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

## License

TBD – Will be added later in the project.
