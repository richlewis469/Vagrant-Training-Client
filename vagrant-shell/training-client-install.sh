#!/usr/bin/env bash

echo " "
echo "training-client-install.sh: Entering Training Provisoning"

echo " "

# Setup for Traning Client

# Install Languages
yum install python2 -y
yum install ruby -y
yum install java -y

# Install  Tools
yum install git -y
yum install terraform -y
yum install terraform-provider-oci -y

# https://github.com/atom/atom
yum install lsb-core-noarch -y
yum install libXScrnSaver -y
yum install libsecret -y
wget --quiet https://github.com/atom/atom/releases/download/v1.22.1/atom.x86_64.rpm
rpm -i atom.x86_64.rpm

# Install chefdk
wget --quiet https://packages.chef.io/files/stable/chefdk/2.3.4/el/7/chefdk-2.3.4-1.el7.x86_64.rpm
rpm -i chefdk-2.3.4-1.el7.x86_64.rpm

# Install Jenkins
# https://pkg.jenkins.io/redhat-stable/
wget --quiet -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install jenkins -y
systemctl restart jenkins
systemctl enable jenkins
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --zone=public --add-service=http --permanent
firewall-cmd --zone=public --add-service=https --permanent
firewall-cmd --reload
grep -A 5 password /var/log/jenkins/jenkins.log | tee /vagrant_share/jenkins.log

echo " "
echo "training-client-install.sh: Exiting Training Provisoning"
