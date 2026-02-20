variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Name of the Hetzner Cloud project"
  type        = string
  default     = "sftp-project"
}

variable "network_zone" {
  description = "Hetzner Cloud network zone for the subnet"
  type        = string
  default     = "eu-central"
}

variable "net_range" {
  description = "CIDR block for the network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "deployer_ssh_public_keys" {
  description = "List of public SSH keys to add to servers"
  type        = list(string)
  default     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMCijVu86B70NyfUF0QmYz3Wt/FWBeNYPPpBdZMJCwDQ"]
}

variable "ssh_allowed_ips" {
  description = "IPs allowed to access the servers via SSH"
  type        = list(string)
}

variable "server_type" {
  description = "Type of Hetzner Cloud server to create"
  type        = string
  default     = "cx23"
}

variable "server_image" {
  description = "Image to use for the servers"
  type        = string
  default     = "ubuntu-24.04"
}

variable "server_location" {
  description = "Location for the servers"
  type        = string
  default     = "nbg1"
}

variable "env" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "sftp_client_allowed_ips" {
  description = "List of IPs allowed to access the SFTP server on port 2222"
  type        = list(string)
  default     = [ ]
}