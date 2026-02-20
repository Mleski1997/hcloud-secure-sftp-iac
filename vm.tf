resource "hcloud_server" "jump_host" {
  name        = "${var.env}-jump-host"
  server_type = var.server_type
  image       = var.server_image
  location    = var.server_location
  ssh_keys    = [hcloud_ssh_key.ssh_key.id]

  public_net {
    ipv4_enabled = true
  }

  user_data = templatefile("${path.module}/templates/user_data.yaml.tftpl", {
    ssh_key = var.ssh_keys[0]
  })

  labels = {
    ssh = "ssh_host"
    env = var.env
  }
}

resource "hcloud_server" "sftp" {
  name        = "${var.env}-sftp"
  server_type = var.server_type
  image       = var.server_image
  location    = var.server_location
  ssh_keys    = [hcloud_ssh_key.ssh_key.id]

  public_net {
    ipv4_enabled = true
  }

  user_data = templatefile("${path.module}/templates/user_data.yaml.tftpl", {
    ssh_key = var.ssh_keys[0]

  })

  labels = {
    ssh = "ssh_sftp"
    env = var.env
  }
}

resource "hcloud_ssh_key" "ssh_key" {
  name       = "${var.env}-${var.project_name}-ssh-key"
  public_key = var.ssh_keys[0]
}