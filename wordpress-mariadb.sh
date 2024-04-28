#!/bin/bash

#Update and install MariaDB
dnf update -y
dnf install net-tools bind-utils nmap-ncat vim -y
setenforce 0
sed -i{,.$(date +%Y%m%d-%H%M)} 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
dnf config-manager --set-enabled crb
dnf install \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm \
    https://dl.fedoraproject.org/pub/epel/epel-next-release-latest-9.noarch.rpm -y
dnf install mariadb-server mariadb -y
systemctl start mariadb
systemctl enable mariadb

# Configure secure DB
mysql -e "SET PASSWORD FOR 'root'@'localhost'=PASSWORD ('D@rkL0rdS1th');"
cat << EOF | tee /root/.my.cnf
[client]
user=root
password=D@rkL0rdS1th
EOF
mysql -e "GRANT ALL PRIVILEGES ON *.* TO root@localhost WITH GRANT OPTION;"


#Update password
#cat << EOF | tee /root/.my.cnf
#[client]
#user=root
#password=D@rkL0rdS1th
#cp -p /etc/my.cnf{,.orig}
#echo "init_file=/var/lib/mysql/mysql.init" >> /etc/my.cnf                           
#cat << EOF | tee /var/lib/mysql/mysql.init
#SET PASSWORD FOR 'root'@'localhost'=PASSWORD ('D@rkL0rdS1th');
#EOF
#systemctl restart mariadb
#mv -f /etc/my.cnf.orig /etc/my.cnf

#Configure WordpressDB
#Wordpress https://wiki.crowncloud.net/?How_to_Install_WordPress_on_Rocky_Linux_9

mysql -e "CREATE DATABASE wordpress;"
mysql -e "CREATE USER 'wordpressusr'@'10.%' IDENTIFIED BY 'la#;(gT2HBCHSpWV1D0woD4R';"
mysql -e "GRANT ALL ON wordpress.* TO 'wordpressusr'@'10.%';"
mysql -e "FLUSH PRIVILEGES;"
