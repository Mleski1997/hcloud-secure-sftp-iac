resource "local_file" "ansible_inventory" {
  content = <<-EOT
    [jump_host]
    jump_host ansible_host=${hcloud_server.jump_host.ipv4_address} ansible_user=deployer ansible_port=22

    [sftp]
    sftp_server ansible_host=${hcloud_server_network.sftp_network.ip} ansible_user=deployer ansible_port=22

    [sftp:vars]
    ansible_ssh_common_args='-o ProxyJump=deployer@${hcloud_server.jump_host.ipv4_address} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
  EOT

  filename = "${path.module}/ansible/inventory.ini"

  
  depends_on = [
    hcloud_server_network.jump_host_network,
    hcloud_server_network.sftp_network
  ]
}