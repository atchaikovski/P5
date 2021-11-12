/*
resource "aws_route53_record" "windows" {
  zone_id = data.aws_route53_zone.link.zone_id
  name    = var.win_host_name
  type    = "A"
  ttl     = "300"
  records = [aws_eip.windows_static_ip.public_ip]
}
*/

resource "aws_route53_record" "artifactory" {
  zone_id = data.aws_route53_zone.link.zone_id
  name    = var.jfrog_host_name
  type    = "A"
  ttl     = "300"
  records = [aws_eip.jfrog_static_ip.public_ip]
}

/*
resource "aws_route53_record" "nginx" {
  zone_id = data.aws_route53_zone.link.zone_id
  name    = var.nginx_host_name
  type    = "A"
  ttl     = "300"
  records = [aws_eip.nginx_static_ip.public_ip]
}
*/