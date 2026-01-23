# Ansible Bootstrap

This directory contains Ansible configuration used to bootstrap and manage
all servers in the Cloud DevOps Lab.

## Inventory

- Hosts are grouped by role: `bastion`, `app`, `monitoring`
- The jump server is used as a bastion for accessing private hosts
- SSH agent forwarding is used; private keys never leave the local machine

## Roles

### common

- Verifies basic connectivity (`ping`)
- Used as a baseline dependency for all other roles

### bootstrap_users

- Creates a non-root `devops` user
- Adds the user to the `sudo` group
- Configures passwordless sudo (temporary)
- Installs SSH public keys

## Execution

Run from the `ansible/` directory:

```bash
ansible-playbook playbooks/....
```

## Ansible Vault

Secrets are stored in:

- group_vars/\*/vault.yml

Run playbooks with:
ansible-playbook playbooks/<playbook>.yml --vault-password-file vault_pass.txt
