#!/bin/zsh

set -ex 
# pack the things
echo "files for nginx server"
if [ -f package.tar.gz ] 
then
  rm package.tar.gz
fi

tar czvf package.tar.gz scripts/nginx_packages.sh configs/nginx.conf configs/mynginx.conf secrets/server.crt secrets/server.key secrets/ca.crt

# terraform apply
echo "applying the config by terraform"
terraform apply -auto-approve