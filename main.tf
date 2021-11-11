locals {
  start = [22, 80, 8080] # from_ports
  end   = [22, 80, 8080] # to_ports
}

### SG for artifactory
resource "aws_security_group" "jfrog_server" {
  name = "jfrog Security Group"

  vpc_id = data.aws_vpc.default.id

  dynamic "ingress" {
    #for_each = var.allowed_ports
    for_each = local.start
    content {
      from_port   = ingress.value
      to_port     = element(local.end, index(local.start,ingress.value))
      protocol    = "tcp"
      cidr_blocks = data.aws_vpc.default.cidr_block
      ipv6_cidr_blocks = data.aws_vpc.default.cidr_block      
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

### SG for nginx
resource "aws_security_group" "nginx_server" {
  name        = "nginx security group"
  description = "Allow HTTPS inbound traffic"
  vpc_id = data.aws_vpc.default.id

  ingress = [
    {
      description      = "HTTPS from VPC"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks = ["0.0.0.0/0"]

      #cidr_blocks      = [aws_vpc.main.cidr_block]
      #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
    }
  ingress = [
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks = ["0.0.0.0/0"]

      #cidr_blocks      = [aws_vpc.main.cidr_block]
      #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
    }

  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

  tags = {
    Name = "HTTPS and SSH to this server"
  }
}

resource "aws_eip" "jfrog_static_ip" {
  instance = aws_instance.jfrog_server.id
  tags = merge(var.common_tags, { Name = "${var.common_tags["Purpose"]} Server IP" })
}