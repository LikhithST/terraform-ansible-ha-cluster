output "web_ips" {
  value = [for c in docker_container.web : c.network_data[0].ip_address]
}

output "lb_ip" {
  value = docker_container.lb.network_data[0].ip_address
}