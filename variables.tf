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

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "ssh_keys" {
  description = "List of SSH key names to be added to the server"
  type        = list(string)
  default     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMCijVu86B70NyfUF0QmYz3Wt/FWBeNYPPpBdZMJCwDQ mleski1997@gmail.com"]
}


variable "ssh_allowed_ips" {
  description = "List of IPs allowed to access the SFTP server via SSH"
  type        = list(string)
  default     = ["192.168.1.0/32"]
}

