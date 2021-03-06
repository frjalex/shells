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
mysql -u root -p$password -e"create database radius"
mysql -u root -p$password -e`grant all on radius.* to radius@localhost identified by "radpass"`

#导入表结构
mysql -uroot -p$password radius < /etc/raddb/sql/mysql/schema.sql
mysql -uroot -p$password radius < /etc/raddb/sql/mysql/nas.sql

wget -q --no-check-certificate https://raw.githubusercontent.com/zihuxinyu/shells/master/freeradius-serverside/radius-db.sql
#导入表初始化结构
mysql -uroot -p$password radius < radius-db.sql

clear

#####
#配置freeradius
#####
rm -f  /etc/raddb/radiusd.conf
wget -q --no-check-certificate https://raw.githubusercontent.com/zihuxinyu/shells/master/freeradius-serverside/etc/raddb/radiusd.conf
mv radiusd.conf /etc/raddb/

rm -f  /etc/raddb/sites-enabled/defaul
wget -q --no-check-certificate https://raw.githubusercontent.com/zihuxinyu/shells/master/freeradius-serverside/etc/raddb/sites-enabled/default
mv default /etc/raddb/sites-enabled/


rm -f  /etc/raddb/sql.conf
wget  --no-check-certificate https://raw.githubusercontent.com/zihuxinyu/shells/master/freeradius-serverside/etc/raddb/sql.conf
mv sql.conf  /etc/raddb/

rm -f  /etc/raddb/dictionary
wget -q --no-check-certificate https://raw.githubusercontent.com/zihuxinyu/shells/master/freeradius-serverside/etc/raddb/dictionary
mv dictionary  /etc/raddb/

rm -f  /etc/raddb/sql/mysql/counter.conf
wget -q --no-check-certificate https://raw.githubusercontent.com/zihuxinyu/shells/master/freeradius-serverside/etc/raddb/sql/mysql/counter.conf
mv counter.conf  /etc/raddb/sql/mysql/





