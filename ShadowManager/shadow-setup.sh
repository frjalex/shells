#!/bin/sh
yum install -y m2crypto python-setuptools gcc-c++ tcl unzip nano
easy_install pip
pip install supervisor

rm -rf /var/proxy
mkdir /var/proxy
mkdir /var/proxy/web

cd /var/proxy/web/
wget https://raw.githubusercontent.com/zihuxinyu/shells/master/ShadowManager/ShadowManage  --no-check-certificate
chmod +x ShadowManage

cd /var/proxy/
wget https://raw.githubusercontent.com/zihuxinyu/shells/master/ShadowManager/server  --no-check-certificate
chmod +x server

cd /var/proxy/web/
wget https://raw.githubusercontent.com/zihuxinyu/shells/master/ShadowManager/web.zip  --no-check-certificate
unzip web.zip
rm -f web.zip






#采用本机公网绑定，防止代理使用127.0.0.1访问本机资源
rm -f  /var/proxy/web/conf/app.conf
echo "appname = ShadowManage">>/var/proxy/web/conf/app.conf
echo "httpport = 5009">>/var/proxy/web/conf/app.conf
echo "runmode = prod">>/var/proxy/web/conf/app.conf
echo "autorender=false">>/var/proxy/web/conf/app.conf
echo "enablegzip=true">>/var/proxy/web/conf/app.conf
echo "httpaddr="`ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk 'NR==1 { print $1}'`>>/var/proxy/web/conf/app.conf


#加入Supervisord配置
rm -f /etc/supervisord.conf
cat >/etc/supervisord.conf<<EOF

;/etc/supervisord.conf
[unix_http_server]
file = /var/run/supervisor.sock
chmod = 0777
chown= root:root


[inet_http_server]
# Web管理界面设定
port=127.0.0.1:5008
#此处改为本机IP地址，防止localhost使用
username = dabao
password = dabao


[supervisorctl]
; 必须和'unix_http_server'里面的设定匹配
serverurl = unix:///var/run/supervisor.sock
[supervisord]
logfile=/var/log/supervisord.log ; (main log file;default $CWD/supervisord.log)
logfile_maxbytes=50MB       ; (max main logfile bytes b4 rotation;default 50MB)
logfile_backups=1          ; (num of main logfile rotation backups;default 10)
loglevel=info               ; (log level;default info; others: debug,warn,trace)
pidfile=/var/run/supervisord.pid ; (supervisord pidfile;default supervisord.pid)
nodaemon=true              ; (start in foreground if true;default false)
minfds=1024                 ; (min. avail startup file descriptors;default 1024)
minprocs=200                ; (min. avail process descriptors;default 200)
user=root                 ; (default is current user, required if root)
childlogdir=/var/log/            ; ('AUTO' child log dir, default $TEMP)
[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface


[program:ssweb]
command=/var/proxy/web/ShadowManage
process_name=ssweb
numprocs=1
numprocs_start=1
autostart = true
startsecs=5
user=root
redirect_stderr=true


[program:ssserver]
command=/var/proxy/server
process_name=ssserver
numprocs=1
numprocs_start=1
autostart = true
startsecs=5
user=root
redirect_stderr=true
EOF

sed -i "s/127.0.0.1/`ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk 'NR==1 { print $1}'`/g" /etc/supervisord.conf
nano /etc/supervisord.conf /var/proxy/web/conf/app.conf
supervisrod