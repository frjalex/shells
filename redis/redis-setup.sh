#!/bin/sh



####
# Download and install Redis:
####
wget -q http://download.redis.io/redis-stable.tar.gz
tar xzf redis-stable.tar.gz
rm -f redis-stable.tar.gz
cd redis-stable
make
make install


####
# Set up Redis
####
rm -rf /etc/redis /var/lib/redis
mkdir /etc/redis /var/lib/redis
cp src/redis-server src/redis-cli /usr/local/bin
cp redis.conf /etc/redis
sed -e "s/^daemonize no$/daemonize yes/"  -e "s/^dir \.\//dir \/var\/lib\/redis\//" -e "s/^loglevel verbose$/loglevel notice/" -e "s/^logfile stdout$/logfile \/var\/log\/redis.log/" redis.conf > /etc/redis/redis.conf

####
# Redis correctly installed.
# Download script for running Redis
####
wget -q https://raw.githubusercontent.com/zihuxinyu/shells/master/redis/redis-server
mv redis-server /etc/init.d
chmod 755 /etc/init.d/redis-server
chkconfig --add redis-server
chkconfig --level 345 redis-server on
####
# To start Redis just uncomment this line
####
service redis-server start