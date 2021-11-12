### Artifactory server
resource "aws_instance" "jfrog_server" {
  ami                         = "ami-0affd4508a5d2481b"
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.jfrog_server.id]
  monitoring                  = var.enable_detailed_monitoring
  key_name                    = "aws_adhoc"
  associate_public_ip_address = true
  #user_data                   = "${file("packages.sh")}"
  
    provisioner "file" {
      source      = "${path.module}/passwd-s3fs"
      destination = "passwd-s3fs"
 
      connection {
         type        = "ssh"
         user        = "centos"
         host        = "${element(aws_instance.jfrog_server.*.public_ip, 0)}"
         private_key = "${file("~/.ssh/aws_adhoc.pem")}"      
      } 
    } 

    provisioner "file" {
      source      = "${path.module}/jfrog_packages.sh"
      destination = "packages.sh"
      
      connection {
         type        = "ssh"
         user        = "centos"
         host        = "${element(aws_instance.jfrog_server.*.public_ip, 0)}"
         private_key = "${file("~/.ssh/aws_adhoc.pem")}"      
      } 
    } 

   provisioner "remote-exec" {
      connection {
         type        = "ssh"
         user        = "centos"
         host        = "${element(aws_instance.jfrog_server.*.public_ip, 0)}"
         private_key = "${file("~/.ssh/aws_adhoc.pem")}"      
      } 

    inline = [
      "sudo chmod 0600 passwd-s3fs",
      "sudo mv passwd-s3fs /etc/passwd-s3fs",
      "sudo chown root:root /etc/passwd-s3fs",
      "chmod +x packages.sh",
      "./packages.sh"
    ]
  }

  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} Server" })

}


resource "aws_instance" "nginx_server" {
  ami                         = "ami-0affd4508a5d2481b"
  instance_type               = var.nginx_instance_type
  vpc_security_group_ids      = [aws_security_group.nginx_server.id]
  monitoring                  = var.enable_detailed_monitoring
  key_name                    = "aws_adhoc"
  associate_public_ip_address = true
  
    provisioner "file" {
      source      = "${path.module}/nginx.conf"
      destination = "nginx.conf"
 
      connection {
         type        = "ssh"
         user        = "centos"
         host        = "${element(aws_instance.jfrog_server.*.public_ip, 0)}"
         private_key = "${file("~/.ssh/aws_adhoc.pem")}"      
      } 
    } 

    provisioner "file" {
      source      = "${path.module}/nginx_packages.sh"
      destination = "packages.sh"
      
      connection {
         type        = "ssh"
         user        = "centos"
         host        = "${element(aws_instance.jfrog_server.*.public_ip, 0)}"
         private_key = "${file("~/.ssh/aws_adhoc.pem")}"      
      } 
    } 

   provisioner "remote-exec" {
      connection {
         type        = "ssh"
         user        = "centos"
         host        = "${element(aws_instance.nginx_server.*.public_ip, 0)}"
         private_key = "${file("~/.ssh/aws_adhoc.pem")}"      
      } 

    inline = [
      "chmod +x packages.sh",
      "./packages.sh"
    ]
  }

  tags = merge(var.common_tags, { Name = "${var.common_tags["Purpose"]} Server" })

}
