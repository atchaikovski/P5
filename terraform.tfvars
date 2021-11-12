region                     = "us-east-1"
nginx_instance_type        = "t2.micro"
instance_type              = "t2.medium"
enable_detailed_monitoring = true

common_tags = {
  Owner       = "Alex Tchaikovski"
  Project     = "Jenkins + JFrog"
  Purpose     = "HTTPS for JFrog"
}


jfrog_host_name = "jfrog"
nginx_host_name = "nginx"
win_host_name = "windows"