resource "hcloud_server" "jump_host" {
  name        = "jump-host"
  server_type = var.server_type
  image       = var.server_image
  location    = var.server_location
  ssh_keys    = [hcloud_ssh_key.ssh_key.id]

  public_net {
    ipv4_enabled = true
  }

  user_data = templatefile("${path.module}/templates/user_data_jump.yaml.tftpl", {
    ssh_key = var.ssh_keys[0]
  })

  labels = {
    ssh     = "ssh_host"
  }
}

resource "hcloud_server" "sftp" {
  name        = "sftp"
  server_type = var.server_type
  image       = var.server_image
  location    = var.server_location
  ssh_keys    = [hcloud_ssh_key.ssh_key.id]

  public_net {
    ipv4_enabled = true
  }
 

  user_data = templatefile("${path.module}/templates/user_data_sftp.yaml.tftpl", {
    ssh_key = var.ssh_keys[0]
  
  })

  labels = {
    ssh     = "ssh_sftp"
  }
}

resource "hcloud_ssh_key" "ssh_key" {
  name       = "mleski_key"
  public_key = var.ssh_keys[0]
}