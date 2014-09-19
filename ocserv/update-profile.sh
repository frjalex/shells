#!/bin/sh
####
# 安装客户端第一次访问时同步的配置文件
# Download profile.xml file
####
rm -f /etc/ocserv/profile.xml
wget -q https://raw.githubusercontent.com/zihuxinyu/shells/master/ocserv/etc/ocserv/profile.xml
mv profile.xml /etc/ocserv/
