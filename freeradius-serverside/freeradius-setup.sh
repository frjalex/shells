#!/bin/sh
#####
#安装freeradius
#####
echo "安装freeradius"
yum install -y freeradius freeradius-mysql freeradius-utils
/etc/init.d/radiusd start
chkconfig radiusd on
clear



#####
#安装mysql
#####
echo "安装mysql"
#todo:设置为unix文件连接
yum -y install mysql mysql-server mysql-devel
/etc/init.d/mysqld start
chkconfig mysqld on
echo "请输入mysql root 密码："
read password
mysqladmin -u root password $password



#创建radius使用的用户
mysql -u root -p$password
mysql>create database radius;
mysql>grant all on radius.* to radius@localhost identified by "radpass";
mysql>exit;
#导入表结构
mysql -uroot -p$password radius < /etc/raddb/sql/mysql/schema.sql

wget -q https://raw.githubusercontent.com/zihuxinyu/shells/master/freeradius-serverside/radius-db.sql
#导入表初始化结构
mysql -uroot -p$password radius < radius-db.sql

clear

#####
#配置freeradius
#####
rm -f  /etc/raddb/radiusd.conf
wget -q https://raw.githubusercontent.com/zihuxinyu/shells/master/freeradius-serverside/etc/raddb/radiusd.conf
mv radiusd.conf /etc/raddb/

rm -f  /etc/raddb/sites-enabled/defaul
wget -q https://raw.githubusercontent.com/zihuxinyu/shells/master/freeradius-serverside/etc/raddb/sites-enabled/defaul
mv defaul /etc/raddb/sites-enabled/


rm -f  /etc/raddb/sql.conf
wget -q https://raw.githubusercontent.com/zihuxinyu/shells/master/freeradius-serverside/etc/raddb/sql.conf
mv sql.conf  /etc/raddb/

rm -f  /etc/raddb/dictionary
wget -q https://raw.githubusercontent.com/zihuxinyu/shells/master/freeradius-serverside/etc/raddb/dictionary
mv dictionary  /etc/raddb/

rm -f  /etc/raddb/sql/mysql/counter.conf
wget -q https://raw.githubusercontent.com/zihuxinyu/shells/master/freeradius-serverside/etc/raddb/sql/mysql/counter.conf
mv counter.conf  /etc/raddb/sql/mysql/




echo "请输入认证服务器密码，其他服务器连接过来需要使用本密码验证："
read pasw
rm -f  /etc/raddb/clients.conf
wget -q https://raw.githubusercontent.com/zihuxinyu/shells/master/freeradius-serverside/etc/raddb/clients.conf
mv clients.conf  /etc/raddb/

sed -i "s/mima/`$pasw`/g" /etc/raddb/clients.conf

