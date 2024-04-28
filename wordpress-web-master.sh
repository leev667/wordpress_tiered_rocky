#!/bin/bash

#Update add epel repo and set selinux to permissive
dnf update -y
dnf install net-tools bind-utils nmap-ncat vim -y
setenforce 0
sed -i{,.$(date +%Y%m%d-%H%M)} 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
dnf config-manager --set-enabled crb
dnf install \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm \
    https://dl.fedoraproject.org/pub/epel/epel-next-release-latest-9.noarch.rpm -y

#Install httpd, php and php-modules
#LAMP https://wiki.crowncloud.net/?How_to_Install_LAMP_Stack_on_Rocky_Linux_9
dnf install httpd httpd-tools php php-zip php-intl php-mysqlnd php-dom php-simplexml php-xml php-xmlreader php-curl php-exif php-ftp php-gd php-iconv php-json php-mbstring php-posix php-sockets php-tokenizer -y
systemctl start httpd
systemctl enable httpd

#Mount NFS
chown apache:apache /var/www/html
dnf install nfs-utils -y
mount -t nfs4 -o sync 10.0.0.10:/web-shares /var/www/html
tail -1 /etc/mtab >> /etc/fstab
