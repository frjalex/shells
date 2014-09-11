#!/bin/sh
mkdir /var/proxy
mkdir /var/proxy/web

cd /var/proxy/web/
wget https://raw.githubusercontent.com/zihuxinyu/shells/master/ShadowManager/ShadowManage  --no-check-certificate
chmod +x ShadowManage

cd /var/proxy/
wget https://raw.githubusercontent.com/zihuxinyu/shells/master/ShadowManager/server  --no-check-certificate
chmod +x server