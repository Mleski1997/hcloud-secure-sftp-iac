# SFTP Infrastructure on Hetzner Cloud

Infrastructure as Code (IaC) project for a secure SFTP setup on Hetzner Cloud.
Terraform provisions infrastructure, and Ansible applies host configuration.

## Architecture

- Business users connect to SFTP on port `2222`.
- Administrators connect through a jump host (`ProxyJump`).
- SSH access to the SFTP server on port `22` is allowed only from the private network.

  <img width="1419" height="630" alt="image" src="https://github.com/user-attachments/assets/2c3f51ee-a179-4edb-85e5-0b203becc5de" />


## Requirements

- Terraform (https://www.terraform.io/) `>= 1.0`
- Ansible (https://www.ansible.com/) `2.9+`
- Hetzner Cloud account and API token

## Quick Start

### 1 Configure Terraform variables

cp terraform.tfvars.example terraform.tfvars


Edit `terraform.tfvars` and set:

- `hcloud_token`
- `ssh_allowed_ips` (your admin public IPs for SSH access)
- `sftp_client_allowed_ips` (allowed client IPs for SFTP on port `2222`) should be explicitly set. The default is empty for safer behavior.


### 2 Configure SFTP users

Edit `ansible/group_vars/sftp.yml`:

sftp_users:
  - name: client1
    key: "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI..."
  - name: client2
    key: "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI..."

### 3 Provision infrastructure


terraform init
terraform plan
terraform apply

### 4 Configure servers


ansible-playbook -i ansible/inventory.ini ansible/site.yml


### 5 Connect

- Jump host: `ssh jump_host` (using generated `ssh_config`)
- SFTP: `sftp -P 2222 <user>@<sftp_public_ip>` (`<sftp_public_ip>` from Terraform output `sftp_server`)

## Project Structure

├── vm.tf
├── network.tf
├── variables.tf
├── outputs.tf
├── ansible.tf
├── ssh_config.tf
├── providers.tf
├── versions.tf
├── templates/
│   └── user_data.yaml.tftpl
├── ansible/
│   ├── site.yml
│   ├── inventory.ini
│   ├── group_vars/
│   └── roles/
│       ├── common
│       ├── jump_host
│       ├── sftp_server
│       
└── terraform.tfvars.example


00Each SFTP user gets a chrooted directory at `/home/<user>/sftp`.

## Outputs

- `jump_host_public_ip`: public IP of jump host
- `sftp_server`: public IP of SFTP server

## Security Decisions

- Jump host for administrative SSH access.
- Private network between jump host and SFTP server.
- Firewall rules for restricted inbound access.
- Separate ports: `22` for admin SSH, `2222` for SFTP clients.
- Chrooted SFTP user directories.
- Password authentication disabled in SSH.

## Manual Test Plan

- Run `terraform validate` before `terraform apply`.
- Verify firewall configuration in Hetzner Cloud console.
- Run `ansible-playbook -i ansible/inventory.ini ansible/site.yml --check`.
- Verify SSH daemon config: `sshd -t` on both hosts.
- Verify SFTP login with SSH key on port `2222`.
- Confirm no shell access for SFTP users (`/usr/sbin/nologin`).

## Cleanup

bash
terraform destroy

## What I learned

- locals
- Dynamic inventory.ini
- How to set port 2222
- Template file
- Chroot
