#!/bin/bash

# script for the Nginx thing
set -ex

sudo yum install -y -q epel-release
sudo yum install -y -q nginx
sudo yum install -y snapd
sudo snap install core 
sudo snap refresh core
sudo systemctl enable --now snapd.socket
sudo snap install --classic certbot

sudo ln -s /var/lib/snapd/snap /snap
sudo ln -s /snap/bin/certbot /usr/bin/certbot
#sudo certbot certonly --nginx
sudo certbot --nginx
sudo systemctl enable nginx
sudo systemctl start nginx
