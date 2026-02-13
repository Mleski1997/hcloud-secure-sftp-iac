resource "hcloud_network" "sftp_network" {
  name     = "sftp-network"
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "sftp_subnet" {
  type         = "cloud"
  network_id   = hcloud_network.sftp_network.id
  ip_range     = "10.0.1.0/24"
  network_zone = var.network_zone
}

resource "hcloud_firewall" "host_firewall" {
  name = "host-firewall"
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = 22
    source_ips = var.ssh_allowed_ips
  }

  apply_to {
    label_selector = "ss=ssh_host"
  }
}

resource "hcloud_firewall" "sftp_firewall" {
  name = "sftp-firewall"
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = 22
    source_ips = ["10.0.1.5/32"]
  }

  apply_to {
    label_selector = "ss=ssh_sftp"
  }

}

#Management IPS for VMs
resource "hcloud_server_network" "jump_host_network" {
  network_id = hcloud_network.sftp_network.id
  server_id  = hcloud_server.jump_host.id
  ip         = cidrhost(var.subnet_cidr, 5)
}
    
resource "hcloud_server_network" "sftp_network" {
  network_id = hcloud_network.sftp_network.id
  server_id  = hcloud_server.sftp.id
  ip         = cidrhost(var.subnet_cidr, 10)
}

