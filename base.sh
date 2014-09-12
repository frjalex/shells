#!/bin/sh
#####
# redis 安装
#####
wget -q https://raw.githubusercontent.com/zihuxinyu/shells/master/redis/redis-setup.sh
chmod +x redis-setup.sh
./redis-setup.sh


#####
# shadowsocks 安装,依赖redis sockfile连接
#####
rm -f shadow-setup.sh
wget https://raw.githubusercontent.com/zihuxinyu/shells/master/ShadowManager/shadow-setup.sh
chmod +x shadow-setup.sh
./shadow-setup.sh


#####
# Cisco anyconnect 安装，默认pam radius
#####
wget -q  https://raw.githubusercontent.com/zihuxinyu/shells/master/ocserv/ocserv-setup.sh
chmod +x ocserv-setup.sh
./ocserv-setup.sh




#####
# Freeradius 服务端 安装
#####
wget -q  https://raw.githubusercontent.com/zihuxinyu/shells/master/freeradius-serverside/freeradius-setup.sh
chmod +x freeradius-setup.sh
./freeradius-setup.sh

