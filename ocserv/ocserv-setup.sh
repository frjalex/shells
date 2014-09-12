#!/bin/sh

####
# 安装cisco anyconnetc 验证环境 centos 6.5
####


yum update -y
yum install -y autoconf gnutls-utils automake gcc gmp-devel bison flex  pcre-devel tar net-tools  openssl openssl-devel curl-devel bind-utils  libtasn1-devel zlib zlib-devel trousers trousers-devel gmp-devel gmp xz texinfo libnl-devel libnl tcp_wrappers-libs tcp_wrappers-devel tcp_wrappers dbus dbus-devel ncurses-devel pam pam-devel readline-devel bison bison-devel flex gcc automake autoconf wget
clear



wget http://www.lysator.liu.se/~nisse/archive/nettle-2.7.tar.gz
tar xvf nettle-2.7.tar.gz
cd nettle-2.7
./configure --prefix=/opt/
make && make install
./configure
make && make install
cd ..


wget ftp://ftp.gnutls.org/gcrypt/gnutls/v3.2/gnutls-3.2.12.tar.xz
tar xvf gnutls-3.2.12.tar.xz
cd gnutls-3.2.12
export LD_LIBRARY_PATH=/opt/lib/:/opt/lib64/
NETTLE_CFLAGS="-I/opt/include/" NETTLE_LIBS="-L/opt/lib64/ -lnettle" HOGWEED_CFLAGS="-I/opt/include" HOGWEED_LIBS="-L/opt/lib64/ -lhogweed" ./configure --prefix=/opt/
make && make install
cd ..



wget http://www.carisma.slowglass.com/~tgr/libnl/files/libnl-3.2.25.tar.gz
tar xvf libnl-3.2.25.tar.gz
cd libnl-3.2.25
./configure --prefix=/opt/
make && make install
cd ..



wget ftp://ftp.infradead.org/pub/ocserv/ocserv-0.8.4.tar.xz
tar xvf ocserv-0.8.4.tar.xz
cd ocserv-0.8.4
export LD_LIBRARY_PATH=/opt/lib/:/opt/lib64/
LIBGNUTLS_CFLAGS="-I/opt/include/" LIBGNUTLS_LIBS="-L/opt/lib/ -lgnutls" LIBNL3_CFLAGS="-I/opt/include" LIBNL3_LIBS="-L/opt/lib/ -lnl-3 -lnl-route-3" ./configure --prefix=/opt/
make && make install&&cd ..
\cp ocserv-0.8.4/src/ocserv /opt/bin/
\cp ocserv-0.8.4/src/occtl /opt/bin/
\cp ocserv-0.8.4/src/ocpasswd /opt/bin/



####
# 安装PAM 认证
#
####
wget ftp://ftp.freeradius.org/pub/radius/pam_radius-1.3.17.tar.gz
tar -xzvf pam_radius-1.3.17.tar.gz
cd pam_radius-1.3.17 && make
cp pam_radius_auth.so /lib/security/pam_radius_auth.so
cd ..


####
# 创建认证配置文件
#
####

mkdir /etc/raddb


#设置radis 认证服务器IP
echo '请输入radis 认证服务器IP:'
read ip
echo '请输入radis 认证服务器秘钥:'
read secret
echo $ip    $secret >>/etc/pam_radius_auth.conf
cp /etc/pam_radius_auth.conf /etc/raddb/server

####
# 下载ocserv 使用PAM认证管理radis的文件
# Download config file
####
rm -f  /etc/pam.d/ocserv
wget -q https://raw.githubusercontent.com/zihuxinyu/shells/master/ocserv/etc/pam.d/ocserv
mv ocserv /etc/pam.d/

####
# 配置信息保存
#
####

echo "export LD_LIBRARY_PATH=/opt/lib/:/opt/lib64/">> /etc/profile
echo 'export PATH=$PATH:/opt/bin'>> /etc/profile
source /etc/profile

rm -rf  /etc/ocserv
mkdir /etc/ocserv

####
# 证书
#
####


certtool --generate-privkey --outfile ca-key.pem

cat << _EOF_ >ca.tmpl
cn = "8dat.com VPN"
organization = "8dat.com"
serial = 1
expiration_days = 3650
ca
signing_key
cert_signing_key
crl_signing_key
_EOF_

    certtool --generate-self-signed --load-privkey ca-key.pem \
    --template ca.tmpl --outfile ca-cert.pem
    certtool --generate-privkey --outfile server-key.pem

cat << _EOF_ >server.tmpl
cn = "8dat.com VPN"
organization  = "8dat.com"
serial = 2
expiration_days = 3650
signing_key
encryption_key #only if the generated key is an RSA one
tls_www_server
_EOF_

    certtool --generate-certificate --load-privkey server-key.pem \
    --load-ca-certificate ca-cert.pem --load-ca-privkey ca-key.pem \
    --template server.tmpl --outfile server-cert.pem


#把证书复制到ocserv的配置目录
cp server-cert.pem /etc/ocserv/ && cp server-key.pem /etc/ocserv/




####
# 修改系统配置，允许转发
#
####
sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/g' /etc/sysctl.conf
sysctl -p



####
# ocserv correctly installed.
# Download config file
####
rm -f /etc/ocserv/ocserv.conf
wget -q https://raw.githubusercontent.com/zihuxinyu/shells/master/ocserv/etc/ocserv/ocserv.conf
mv ocserv.conf /etc/ocserv/


####
# 安装客户端第一次访问时同步的配置文件
# Download profile.xml file
####
rm -f /etc/ocserv/profile.xml
wget -q https://raw.githubusercontent.com/zihuxinyu/shells/master/ocserv/etc/ocserv/profile.xml
mv profile.xml /etc/ocserv/


####
# 配置路由
## ocserv 配置的IP地址是如下的，路由信息要对应
#ipv4-network = 192.168.10.0
#ipv4-netmask = 255.255.255.0
#iptables -F -t nat
#iptables -t nat -vnxL
####


iptables -I FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

iptables -A FORWARD -s 192.168.10.0/24 -j ACCEPT

iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -j SNAT --to-source `ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk 'NR==1 { print $1}'`


service iptables save


####
# 设置启动项
wget https://raw.githubusercontent.com/zihuxinyu/shells/master/ocserv/ocserv
rm -f /etc/init.d/ocserv
mv ocserv /etc/init.d/
chmod 755 /etc/init.d/ocserv
chkconfig --add ocserv
chkconfig --level 345 ocserv on
