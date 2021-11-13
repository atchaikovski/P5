#!/bin/bash

# script for the Nginx thing
set -ex

# EPEL
sudo yum install -y -q epel-release

# NGINX
sudo yum install -y -q nginx
sudo systemctl enable nginx
sudo systemctl start nginx
sudo cp ~/nginx.conf /etc/nginx/conf.d/default.conf
sudo cp ./server.crt /etc/nginx/ssl/server.crt
sudo cp ./server.key /etc/nginx/ssl/server.key

# SNAPD
sudo yum install -y -q snapd
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
sleep 60

# CERTBOT
sudo snap install core 
sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
#sudo certbot certonly --nginx
sudo certbot --nginx
