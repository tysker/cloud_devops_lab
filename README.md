# DevOps Project

## Project Description

-- description about the devops project

## Structure

-- tree structure of the project

## Stages

**Stage 1:**

- Basic Flask application running locally.
- Endpoints:
  - `/` – root
  - `/health`
  - `/metrics/custom` (coming soon)

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
