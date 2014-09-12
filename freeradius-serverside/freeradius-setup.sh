#!/bin/sh
#####
#安装freeradius
#####
echo "安装freeradius"
yum install -y freeradius freeradius-mysql freeradius-utils
/etc/init.d/radiusd start
chkconfig radiusd on
clear

echo "安装mysql"
#todo:设置为unix文件连接
yum -y install mysql mysql-server mysql-devel
/etc/init.d/mysqld start
chkconfig mysqld on
echo "请输入mysql root 密码："
read password
mysqladmin -u root password $password
clear
