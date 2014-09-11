#!/bin/sh
mkdir /var/proxy
mkdir /var/proxy/web
cd /var/proxy/web/
wget https://github.com/zihuxinyu/go/blob/master/src/ShadowManage/linux_x86/ShadowManage  --no-check-certificate
chmod +x ShadowManage
cd /var/proxy/
wget https://github.com/zihuxinyu/go/blob/master/src/ShadowManage/linux_x86/server  --no-check-certificate
chmod +x server