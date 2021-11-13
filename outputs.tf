output "artifactory_server_ip" {
  value = aws_eip.jfrog_static_ip.public_ip
}

output "tchaikovski-public-zone-id" {
  value = ""
}
