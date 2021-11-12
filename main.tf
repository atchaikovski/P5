locals {
  jfrog_start = [22, 80, 8040] # from_ports
  jfrog_end   = [22, 80, 8090] # to_ports
}

### SG for artifactory
resource "aws_security_group" "jfrog_server" {
  name = "jfrog Security Group"

  vpc_id = data.aws_vpc.default.id

  dynamic "ingress" {

    for_each = local.jfrog_start
    content {
      from_port   = ingress.value
      to_port     = element(local.jfrog_end, index(local.jfrog_start,ingress.value))
      protocol    = "tcp"
      cidr_blocks = [data.aws_vpc.default.cidr_block]
      ipv6_cidr_blocks = [data.aws_vpc.default.cidr_block]      
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "${var.common_tags["Purpose"]} SecurityGroup" })

}

locals {
  nginx_start = [22, 80, 443] # from_ports
  nginx_end   = [22, 80, 443] # to_ports
}

### SG for nginx
resource "aws_security_group" "nginx_server" {
  name        = "nginx security group"
  description = "Allow HTTPS inbound traffic"
  vpc_id = data.aws_vpc.default.id

    dynamic "ingress" {
    #for_each = var.allowed_ports
    for_each = local.nginx_start
       content {
         from_port   = ingress.value
         to_port     = element(local.nginx_end, index(local.nginx_start,ingress.value))
         protocol    = "tcp"
         cidr_blocks = [data.aws_vpc.default.cidr_block]
         ipv6_cidr_blocks = [data.aws_vpc.default.cidr_block]      
       }
    }


  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

  tags = {
    Name = "HTTPS and SSH to this server"
  }
}

resource "aws_eip" "jfrog_static_ip" {
  instance = aws_instance.jfrog_server.id
  tags = merge(var.common_tags, { Name = "${var.common_tags["Purpose"]} Server IP" })
}

resource "aws_eip" "nginx_static_ip" {
  instance = aws_instance.nginx_server.id
  tags = merge(var.common_tags, { Name = "${var.common_tags["Purpose"]} Server IP" })
}