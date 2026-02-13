output "jump_host_public_ip" {
  value       = hcloud_server.jump_host.ipv4_address
  description = "Public IP address of the jump host server"

}