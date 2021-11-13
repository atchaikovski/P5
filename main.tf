
resource "aws_eip" "jfrog_static_ip" {
  instance = aws_instance.jfrog_server.id
  tags = merge(var.common_tags, { Name = "${var.common_tags["Purpose"]} Server IP" })
}


resource "aws_eip" "nginx_static_ip" {
  instance = aws_instance.nginx_server.id
  tags = merge(var.common_tags, { Name = "${var.common_tags["Purpose"]} Server IP" })
}
