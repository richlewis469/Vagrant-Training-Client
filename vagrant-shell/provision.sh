#!/usr/bin/env bash

echo " "
echo "provision.sh: Entering Shell Provisoning"

echo " "
/bin/rm /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel-testing.repo
yum makecache fast
yum install deltarpm -y
yum install wget -y

/bin/mv /etc/yum.repos.d/public-yum-ol7.repo /etc/yum.repos.d/public-yum-ol7.repo.orig
wget -q http://yum.oracle.com/public-yum-ol7.repo -P /etc/yum.repos.d

yum install yum-utils -y
yum-config-manager --enable ol7_addons
yum-config-manager --enable ol7_software_collections
yum-config-manager --enable ol7_developer
yum-config-manager --enable ol7_developer_EPEL

yum makecache fast

echo " "
/bin/sed -i.bak -e 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

yum install git -y
yum install curl -y
yum install screen -y

yum install sshd -y
systemctl restart sshd
systemctl enable sshd

# yum groupinstall "Server with GUI" -y
yum install tigervnc-server -y
sudo -u vagrant vncserver << EOF > /tmp/vnc-config.txt 2>&1
vagrant
vagrant
n
EOF
sudo -u vagrant vncserver -kill \:1
cp /usr/lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver-vagrant@\:1.service
/bin/sed -i.bak -e 's/<USER>/vagrant/g' /etc/systemd/system/vncserver-vagrant@\:1.service
systemctl daemon-reload
systemctl start vncserver-vagrant@\:1.service
systemctl enable vncserver-vagrant@\:1.service

yum install ntp -y
systemctl restart ntp
systemctl enable ntp

yum install openssl -y
yum install iptables -y
yum install ip6tables -y
yum install firewalld -y
systemctl restart firewalld
systemctl enable firewalld

firewall-cmd --zone=public --add-service=ssh --permanent
firewall-cmd --zone=public --add-port=vnc-server --permanent
firewall-cmd --zone=public --add-port=5901/tcp --permanent
firewall-cmd --zone=public --add-port=5902/tcp --permanent
firewall-cmd --zone=public --add-port=5903/tcp --permanent
firewall-cmd --zone=public --add-port=5904/tcp --permanent
firewall-cmd --zone=public --add-port=5905/tcp --permanent
firewall-cmd --reload

echo " "
ip addr show

date +"%F %T" > /etc/git-creation-timestamp.txt
echo " "
cat /etc/git-creation-timestamp.txt
echo " "
echo "provision.sh: Exiting Shell Provisoning"
