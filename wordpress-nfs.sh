#!/bin/bash

#Update and install NFS
setenforce 0
sed -i{,.$(date +%Y%m%d-%H%M)} 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
dnf update -y
dnf install net-tools bind-utils nmap-ncat vim -y
dnf install nfs-utils -y
systemctl enable rpcbind
systemctl start rpcbind
systemctl enable nfs-server
systemctl start nfs-server

#Wordpress https://wiki.crowncloud.net/?How_to_Install_WordPress_on_Rocky_Linux_9
mkdir /web-shares
cd /web-shares
curl https://wordpress.org/latest.tar.gz --output wordpress.tar.gz
tar xf wordpress.tar.gz
mv wordpress/* /web-shares
dnf install httpd -y
systemctl mask httpd
chown -R apache:apache /web-shares
find /web-shares -type d -exec chmod 2775 {} +; find /web-shares -type f -exec chmod 644 {} +

#Export directory
cat << EOF | tee /etc/exports
/web-shares 10.0.1.0/24(rw,sync,no_root_squash)
EOF
exportfs -a
systemctl restart nfs-server
systemctl restart rpcbind
