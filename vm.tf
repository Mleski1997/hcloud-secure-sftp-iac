resource "hcloud_server" "jump_host" {
  name        = "jump-host"
  server_type = "cx23"
  image       = "ubuntu-24.04"
  location    = "nbg1"
  ssh_keys    = [hcloud_ssh_key.ssh_key.id]

  public_net {
    ipv4_enabled = true
  }

  labels = {
    project = var.project_name
    role    = "jump_host"
    env     = "prod"
    ssh     = "ssh_host"
  }
}

resource "hcloud_server" "sftp" {
  name        = "sftp"
  server_type = "cx23"
  image       = "ubuntu-24.04"
  location    = "nbg1"
  ssh_keys    = [hcloud_ssh_key.ssh_key.id]

  labels = {
    project = var.project_name
    role    = "sftp"
    env     = "prod"
    ssh     = "ssh_sftp"
  }
}

resource "hcloud_ssh_key" "ssh_key" {
  name       = "mleski_key"
  public_key = var.ssh_keys[0]

}