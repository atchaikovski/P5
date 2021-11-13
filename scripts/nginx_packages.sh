#!/bin/bash

# script for the Nginx thing
set -ex

# SELINUX
sudo setenforce 0

# EPEL
sudo yum install -y -q epel-release

# NGINX
sudo yum install -y -q nginx
sudo systemctl enable nginx

# configuring NGINX
sudo mkdir /etc/nginx/ssl
sudo chmod 644 /etc/nginx/ssl
sudo cp ./server.crt /etc/nginx/ssl/server.crt
sudo cp ./server.key /etc/nginx/ssl/server.key
sudo cp ./nginx.conf /etc/nginx/nginx.conf

sudo cp ./mynginx.conf /etc/nginx/conf.d/default.conf

sudo systemctl start nginx
