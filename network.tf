resource "hcloud_network" "sftp_network" {
  name     = "sftp-network"
  ip_range = var.net_range
}

resource "hcloud_network_subnet" "private_network" {
  type         = "cloud"
  network_id   = hcloud_network.sftp_network.id
  ip_range     = var.subnet_cidr
  network_zone = var.network_zone
}



resource "hcloud_firewall" "host_firewall" {
  name = "host-firewall"
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = var.ssh_allowed_ips
    description = "Allow SSH from allowed IPs"
  
  }

  dynamic "rule" {
      for_each = local.egress_rules
      content {
        description = rule.value.desc
        direction   = "out"
        protocol    = rule.value.protocol
        port        = rule.value.port
        destination_ips = ["0.0.0.0/0", "::/0"]
      }
    }

  apply_to {
    label_selector = "ssh=ssh_host"
  }
}

resource "hcloud_firewall" "sftp_firewall" {
  name = "sftp-firewall"
  rule {
    description = "Allow SSH form Jump Host private IP"
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = ["${hcloud_server_network.jump_host_network.ip}/32"]
  }

  rule {
    description = "Allow SFTP for client from everywhere"
    direction = "in"
    protocol  = "tcp"
    port      = "2222"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

 dynamic "rule" {
      for_each = local.egress_rules
      content {
        description = rule.value.desc
        direction   = "out"
        protocol    = rule.value.protocol
        port        = rule.value.port
        destination_ips = ["0.0.0.0/0", "::/0"]
      }
    }


  apply_to {
    label_selector = "ssh=ssh_sftp"
  }
}

#Management IPS for VMs
resource "hcloud_server_network" "jump_host_network" {
  network_id = hcloud_network.sftp_network.id
  server_id  = hcloud_server.jump_host.id
}
    
resource "hcloud_server_network" "sftp_network" {
  network_id = hcloud_network.sftp_network.id
  server_id  = hcloud_server.sftp.id
}

locals {
  egress_rules = [
    { port = 53, protocol = "udp", desc = "Allow DNS" },
    { port = 53, protocol = "tcp", desc = "Allow DNS" },
    { port = 80, protocol = "tcp", desc = "Allow HTTP outbound" },
    { port = 443, protocol = "tcp", desc = "Allow HTTPS outbound" },
  ]
}

