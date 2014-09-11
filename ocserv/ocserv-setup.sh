#!/bin/sh
yum update -y
yum install -y autoconf gnutls-utils automake gcc gcc wget pcre-devel tar net-tools  openssl openssl-devel curl-devel bind-utils  libtasn1-devel zlib zlib-devel trousers trousers-devel gmp-devel gmp xz texinfo libnl-devel libnl tcp_wrappers-libs tcp_wrappers-devel tcp_wrappers dbus dbus-devel ncurses-devel pam pam-devel readline-devel bison bison-devel flex gcc automake autoconf wget
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