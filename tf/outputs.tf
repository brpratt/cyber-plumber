output "command_public_ip" {
  description = "Public IP of command droplet"
  value       = digitalocean_droplet.command.ipv4_address
}

output "command_private_ip" {
  description = "Private IP of command droplet"
  value       = digitalocean_droplet.command.ipv4_address_private
}

output "jumpbox_private_ips" {
  description = "Private IPs of jumpbox droplets"
  value       = digitalocean_droplet.jumpbox[*].ipv4_address_private
}
