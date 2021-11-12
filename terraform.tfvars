region                     = "us-east-1"
instance_type              = "c3.large"
enable_detailed_monitoring = true

#allowed_ports = ["80", "443", "8040-8090"]

common_tags = {
  Owner       = "Alex Tchaikovski"
  Project     = "Jenkins + JFrog"
  Purpose     = "Artifactory"
}


jfrog_host_name = "jfrog"
nginx_host_name = "nginx"
win_host_name = "windows"