resource "local_file" "ssh_config" {
    content = <<-EOT
    Host jump_host
        HostName ${hcloud_server.jump_host.ipv4_address}
        User deployer
        IdentityFile ~/.ssh/id_ed25519
        StrictHostKeyChecking accept-new

    Host sftp-server
        HostName ${hcloud_server_network.sftp_network.ip}
        User deployer
        ProxyJump jump_host
        StrictHostKeyChecking yes
        IdentityFile ~/.ssh/id_ed25519
    EOT 

    filename = "${path.module}/ssh_config"
            
}