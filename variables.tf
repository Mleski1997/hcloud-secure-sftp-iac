variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive = true
}

variable "ssh_keys" {
  description = "List of SSH key names to be added to the server"
  type        = list(string)
  default = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMCijVu86B70NyfUF0QmYz3Wt/FWBeNYPPpBdZMJCwDQ mleski1997@gmail.com" ]
}