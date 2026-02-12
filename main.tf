resource "hcloud_network" "sftp_network" {
    name = "sftp-network"
    ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "sftp_subnet" {
    type = "cloud"
    network_id = hcloud_network.sftp_network.id
    ip_range = "10.0.1.0/24"
    network_zone = "eu-central"
}