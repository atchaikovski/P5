#!/bin/zsh

set -ex 
# pack the things
echo "files for nginx server"
tar czvf package.tar.gz nginx_packages.sh nginx.conf mynginx.conf server.crt server.key ca.crt

# terraform apply
echo "applying the config by terraform"
terraform apply -auto-approve