#!/bin/bash
sudo yum install -y -q epel-release
sudo yum install -y -q s3fs-fuse

export JFROG_HOME=/opt/jfrog
sudo sh -c "echo 'JFROG_HOME=/opt/jfrog' >>/etc/profile"
echo "what is in JFROG_HOME?  "$JFROG_HOME

export S3_BIN=/opt/s3
export S3_BUCKET=sf-project4-binaries
export JFROG_URL="${host_name}.tchaikovski.link"

echo $JFROG_URL

sudo adduser artifactory
sudo sh -c "echo 'artifactory ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers.d/90-cloud-init-users"

# preparing to mount S3 and copy files
sudo mkdir $S3_BIN
sudo s3fs $S3_BUCKET -o use_cache=/tmp -o allow_other -o uid=1001 -o mp_umask=002 -o multireq_max=5 $S3_BIN

# check if there's anything in S3 and copy/extract/install
if [[ -f "$S3_BIN/jfrog-rpm-installer.tar.gz" ]] 
then
    echo "files of Artifactory found, proceed"
    sudo cp $S3_BIN/jfrog-rpm-installer.tar.gz /opt
    cd /opt
    sudo tar zxvf jfrog-rpm-installer.tar.gz
    sudo mv jfrog-platform-trial-prox-7.27.6-rpm jfrog
    echo "installing as a service for artifactory user"
    cd $JFROG_HOME
    sudo ./install.sh

    echo "starting as a service"
    sudo systemctl start artifactory.service
    sudo systemctl start xray.service

    echo "removing jfrog archive"
    sudo rm /opt/jfrog/artifactory/artifactory.rpm
    sudo rm /opt/jfrog-rpm-installer*

    echo "removing secrets and unwanted stuff..."
    sudo umount $S3_BIN
    sudo rm -rf $S3_BIN   
    sudo rm /etc/passwd-s3fs
    sudo rm -rf /home/centos/s3fs-*

  else

    echo "S3 location with JFrog binaries not found.. fix your S3 access"

fi
