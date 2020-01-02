{\rtf1\ansi\ansicpg1252\cocoartf2511
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\froman\fcharset0 Times-Roman;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;\red0\green0\blue233;}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;\cssrgb\c0\c0\c93333;}
\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\sl280\partightenfactor0

\f0\fs24 \cf2 \expnd0\expndtw0\kerning0
#! /bin/bash \
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin \
export PATH \
#=================================================================# \
#\'a0\'a0 System Required:\'a0 CentOS 6,7, Debian, Ubuntu\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 # \
#\'a0\'a0 Description: One click Install ShadowsocksR Server\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 # \
#\'a0\'a0 Author: 91yun <{\field{\*\fldinst{HYPERLINK "https://twitter.com/91yun"}}{\fldrslt \cf3 \ul \ulc3 https://twitter.com/91yun}}>\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 # \
#\'a0\'a0 Thanks: @breakwa11 <{\field{\*\fldinst{HYPERLINK "https://twitter.com/breakwa11"}}{\fldrslt \cf3 \ul \ulc3 https://twitter.com/breakwa11}}>\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 # \
#\'a0\'a0 Thanks: @Teddysun <{\field{\*\fldinst{HYPERLINK "mailto:i@teddysun.com"}}{\fldrslt \cf3 \ul \ulc3 i@teddysun.com}}>\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 # \
#\'a0\'a0 Intro:\'a0 {\field{\*\fldinst{HYPERLINK "https://www.91yun.org/archives/2079"}}{\fldrslt \cf3 \ul \ulc3 https://www.91yun.org/archives/2079}}\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 # \
#=================================================================# \
\
\
#Current folder \
cur_dir=`pwd` \
# Get public IP address \
IP=$(ip addr | egrep -o '[0-9]\{1,3\}\\.[0-9]\{1,3\}\\.[0-9]\{1,3\}\\.[0-9]\{1,3\}' | egrep -v "^192\\.168|^172\\.1[6-9]\\.|^172\\.2[0-9]\\.|^172\\.3[0-2]\\.|^10\\.|^127\\.|^255\\.|^0\\." | head -n 1) \
if [[ "$IP" = "" ]]; then \
\'a0\'a0\'a0 IP=$(wget -qO- -t1 -T2 {\field{\*\fldinst{HYPERLINK "http://ipv4.icanhazip.com/"}}{\fldrslt \cf3 \ul \ulc3 ipv4.icanhazip.com}}) \
fi \
\
# Make sure only root can run our script \
function rootness()\{ \
\'a0\'a0\'a0 if [[ $EUID -ne 0 ]]; then \
\'a0\'a0\'a0\'a0\'a0\'a0 echo "Error:This script must be run as root!" 1>&2 \
\'a0\'a0\'a0\'a0\'a0\'a0 exit 1 \
\'a0\'a0\'a0 fi \
\} \
\
# Check OS \
function checkos()\{ \
\'a0\'a0\'a0 if [ -f /etc/redhat-release ];then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 OS='CentOS' \
\'a0\'a0\'a0 elif [ ! -z "`cat /etc/issue | grep bian`" ];then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 OS='Debian' \
\'a0\'a0\'a0 elif [ ! -z "`cat /etc/issue | grep Ubuntu`" ];then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 OS='Ubuntu' \
\'a0\'a0\'a0 else \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo "Not support OS, Please reinstall OS and retry!" \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 exit 1 \
\'a0\'a0\'a0 fi \
\} \
\
# Get version \
function getversion()\{ \
\'a0\'a0\'a0 if [[ -s /etc/redhat-release ]];then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 grep -oE\'a0 "[0-9.]+" /etc/redhat-release \
\'a0\'a0\'a0 else\'a0\'a0\'a0 \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 grep -oE\'a0 "[0-9.]+" /etc/issue \
\'a0\'a0\'a0 fi\'a0\'a0\'a0 \
\} \
\
# CentOS version \
function centosversion()\{ \
\'a0\'a0\'a0 local code=$1 \
\'a0\'a0\'a0 local version="`getversion`" \
\'a0\'a0\'a0 local main_ver=$\{version%%.*\} \
\'a0\'a0\'a0 if [ $main_ver == $code ];then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 return 0 \
\'a0\'a0\'a0 else \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 return 1 \
\'a0\'a0\'a0 fi\'a0\'a0\'a0\'a0\'a0\'a0\'a0 \
\} \
\
# Disable selinux \
function disable_selinux()\{ \
if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then \
\'a0\'a0\'a0 sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config \
\'a0\'a0\'a0 setenforce 0 \
fi \
\} \
\
# Pre-installation settings \
function pre_install()\{ \
\'a0\'a0\'a0 # Not support CentOS 5 \
\'a0\'a0\'a0 if centosversion 5; then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo "Not support CentOS 5, please change OS to CentOS 6+/Debian 7+/Ubuntu 12+ and retry." \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 exit 1 \
\'a0\'a0\'a0 fi \
\'a0\'a0\'a0 # Set ShadowsocksR config password \
\'a0\'a0\'a0 echo "Please input password for ShadowsocksR:" \
\'a0\'a0\'a0 read -p "(Default password: {\field{\*\fldinst{HYPERLINK "http://www.91yun.org/"}}{\fldrslt \cf3 \ul \ulc3 www.91yun.org}}):" shadowsockspwd \
\'a0\'a0\'a0 [ -z "$shadowsockspwd" ] && shadowsockspwd="{\field{\*\fldinst{HYPERLINK "http://www.91yun.org/"}}{\fldrslt \cf3 \ul \ulc3 www.91yun.org}}" \
\'a0\'a0\'a0 echo \
\'a0\'a0\'a0 echo "---------------------------" \
\'a0\'a0\'a0 echo "password = $shadowsockspwd" \
\'a0\'a0\'a0 echo "---------------------------" \
\'a0\'a0\'a0 echo \
\'a0\'a0\'a0 # Set ShadowsocksR config port \
\'a0\'a0\'a0 while true \
\'a0\'a0\'a0 do \
\'a0\'a0\'a0 echo -e "Please input port for ShadowsocksR [1-65535]:" \
\'a0\'a0\'a0 read -p "(Default port: 8989):" shadowsocksport \
\'a0\'a0\'a0 [ -z "$shadowsocksport" ] && shadowsocksport="8989" \
\'a0\'a0\'a0 expr $shadowsocksport + 0 &>/dev/null \
\'a0\'a0\'a0 if [ $? -eq 0 ]; then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 if [ $shadowsocksport -ge 1 ] && [ $shadowsocksport -le 65535 ]; then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo "---------------------------" \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo "port = $shadowsocksport" \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo "---------------------------" \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 break \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 else \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo "Input error! Please input correct number." \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 fi \
\'a0\'a0\'a0 else \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo "Input error! Please input correct number." \
\'a0\'a0\'a0 fi \
\'a0\'a0\'a0 done \
\'a0\'a0\'a0 get_char()\{ \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 SAVEDSTTY=`stty -g` \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 stty -echo \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 stty cbreak \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 dd if=/dev/tty bs=1 count=1 2> /dev/null \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 stty -raw \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 stty echo \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 stty $SAVEDSTTY \
\'a0\'a0\'a0 \} \
\'a0\'a0\'a0 echo \
\'a0\'a0\'a0 echo "Press any key to start...or Press Ctrl+C to cancel" \
\'a0\'a0\'a0 char=`get_char` \
\'a0\'a0\'a0 # Install necessary dependencies \
\'a0\'a0\'a0 if [ "$OS" == 'CentOS' ]; then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 yum install -y wget unzip openssl-devel gcc swig python python-devel python-setuptools autoconf libtool libevent git ntpdate \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 yum install -y m2crypto automake make curl curl-devel zlib-devel perl perl-devel cpio expat-devel gettext-devel \
\'a0\'a0\'a0 else \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 apt-get -y update \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 apt-get -y install python python-dev python-pip python-m2crypto curl wget unzip gcc swig automake make perl cpio build-essential git ntpdate \
\'a0\'a0\'a0 fi \
\'a0\'a0\'a0 cd $cur_dir \
\} \
\
# Download files \
function download_files()\{ \
\'a0\'a0\'a0 # Download libsodium file \
\'a0\'a0\'a0 if ! wget --no-check-certificate -O libsodium-1.0.10.tar.gz {\field{\*\fldinst{HYPERLINK "https://github.com/jedisct1/libsodium/releases/download/1.0.10/libsodium-1.0.10.tar.gz"}}{\fldrslt \cf3 \ul \ulc3 https://github.com/jedisct1/libsodium/releases/download/1.0.10/libsodium-1.0.10.tar.gz}}; then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo "Failed to download libsodium file!" \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 exit 1 \
\'a0\'a0\'a0 fi \
\'a0\'a0\'a0 # Download ShadowsocksR file \
\'a0\'a0\'a0 # if ! wget --no-check-certificate -O manyuser.zip {\field{\*\fldinst{HYPERLINK "https://github.com/breakwa11/shadowsocks/archive/manyuser.zip"}}{\fldrslt \cf3 \ul \ulc3 https://github.com/breakwa11/shadowsocks/archive/manyuser.zip}}; then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 # echo "Failed to download ShadowsocksR file!" \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 # exit 1 \
\'a0\'a0\'a0 # fi \
\'a0\'a0\'a0 # Download ShadowsocksR chkconfig file \
\'a0\'a0\'a0 if [ "$OS" == 'CentOS' ]; then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 if ! wget --no-check-certificate {\field{\*\fldinst{HYPERLINK "https://raw.githubusercontent.com/91yun/shadowsocks_install/master/shadowsocksR"}}{\fldrslt \cf3 \ul \ulc3 https://raw.githubusercontent.com/91yun/shadowsocks_install/master/shadowsocksR}} -O /etc/init.d/shadowsocks; then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo "Failed to download ShadowsocksR chkconfig file!" \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 exit 1 \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 fi \
\'a0\'a0\'a0 else \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 if ! wget --no-check-certificate {\field{\*\fldinst{HYPERLINK "https://raw.githubusercontent.com/91yun/shadowsocks_install/master/shadowsocksR-debian"}}{\fldrslt \cf3 \ul \ulc3 https://raw.githubusercontent.com/91yun/shadowsocks_install/master/shadowsocksR-debian}} -O /etc/init.d/shadowsocks; then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo "Failed to download ShadowsocksR chkconfig file!" \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 exit 1 \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 fi \
\'a0\'a0\'a0 fi \
\} \
\
# firewall set \
function firewall_set()\{ \
\'a0\'a0\'a0 echo "firewall set start..." \
\'a0\'a0\'a0 if centosversion 6; then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 /etc/init.d/iptables status > /dev/null 2>&1 \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 if [ $? -eq 0 ]; then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 iptables -L -n | grep '$\{shadowsocksport\}' | grep 'ACCEPT' > /dev/null 2>&1 \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 if [ $? -ne 0 ]; then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $\{shadowsocksport\} -j ACCEPT \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 iptables -I INPUT -m state --state NEW -m udp -p udp --dport $\{shadowsocksport\} -j ACCEPT \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 /etc/init.d/iptables save \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 /etc/init.d/iptables restart \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 else \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo "port $\{shadowsocksport\} has been set up." \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 fi \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 else \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo "WARNING: iptables looks like shutdown or not installed, please manually set it if necessary." \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 fi \
\'a0\'a0\'a0 elif centosversion 7; then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 systemctl status firewalld > /dev/null 2>&1 \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 if [ $? -eq 0 ];then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 firewall-cmd --permanent --zone=public --add-port=$\{shadowsocksport\}/tcp \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 firewall-cmd --permanent --zone=public --add-port=$\{shadowsocksport\}/udp \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 firewall-cmd --reload \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 else \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 /etc/init.d/iptables status > /dev/null 2>&1 \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 if [ $? -eq 0 ]; then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 iptables -L -n | grep '$\{shadowsocksport\}' | grep 'ACCEPT' > /dev/null 2>&1 \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 if [ $? -ne 0 ]; then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $\{shadowsocksport\} -j ACCEPT \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 iptables -I INPUT -m state --state NEW -m udp -p udp --dport $\{shadowsocksport\} -j ACCEPT \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 /etc/init.d/iptables save \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 /etc/init.d/iptables restart \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 else \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo "port $\{shadowsocksport\} has been set up." \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 fi \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 else \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo "WARNING: firewall like shutdown or not installed, please manually set it if necessary." \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 fi\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 fi \
\'a0\'a0\'a0 fi \
\'a0\'a0\'a0 echo "firewall set completed..." \
\} \
\
# Config ShadowsocksR \
function config_shadowsocks()\{ \
\'a0\'a0\'a0 cat > /etc/shadowsocks.json<<-EOF \
\{ \
\'a0\'a0\'a0 "server": "0.0.0.0", \
\'a0\'a0\'a0 "server_ipv6": "::", \
\'a0\'a0\'a0 "server_port": $\{shadowsocksport\}, \
\'a0\'a0\'a0 "local_address": "127.0.0.1", \
\'a0\'a0\'a0 "local_port": 1081, \
\'a0\'a0\'a0 "password": "$\{shadowsockspwd\}", \
\'a0\'a0\'a0 "timeout": 120, \
\'a0\'a0\'a0 "udp_timeout": 60, \
\'a0\'a0\'a0 "method": "chacha20", \
\'a0\'a0\'a0 "protocol": "auth_sha1_v4_compatible", \
\'a0\'a0\'a0 "protocol_param": "", \
\'a0\'a0\'a0 "obfs": "tls1.2_ticket_auth_compatible", \
\'a0\'a0\'a0 "obfs_param": "", \
\'a0\'a0\'a0 "dns_ipv6": false, \
\'a0\'a0\'a0 "connect_verbose_info": 1, \
\'a0\'a0\'a0 "redirect": "", \
\'a0\'a0\'a0 "fast_open": false, \
\'a0\'a0\'a0 "workers": 1 \
\
\} \
EOF \
\} \
\
# Install ShadowsocksR \
function install_ss()\{ \
\'a0\'a0\'a0 # Install libsodium \
\'a0\'a0\'a0 tar zxf libsodium-1.0.10.tar.gz \
\'a0\'a0\'a0 cd $cur_dir/libsodium-1.0.10 \
\'a0\'a0\'a0 ./configure && make && make install \
\'a0\'a0\'a0 echo "/usr/local/lib" > /etc/ld.so.conf.d/local.conf \
\'a0\'a0\'a0 ldconfig \
\'a0\'a0\'a0 # Install ShadowsocksR \
\'a0\'a0\'a0 cd $cur_dir \
\'a0\'a0\'a0 # unzip -q manyuser.zip \
\'a0\'a0\'a0 # mv shadowsocks-manyuser/shadowsocks /usr/local/ \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 git clone {\field{\*\fldinst{HYPERLINK "https://github.com/91yun/shadowsocksr-1.git"}}{\fldrslt \cf3 \ul \ulc3 https://github.com/91yun/shadowsocksr-1.git}} /usr/local/shadowsocks \
\'a0\'a0\'a0 if [ -f /usr/local/shadowsocks/server.py ]; then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 chmod +x /etc/init.d/shadowsocks \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 # Add run on system start up \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 if [ "$OS" == 'CentOS' ]; then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 chkconfig --add shadowsocks \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 chkconfig shadowsocks on \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 else \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 update-rc.d -f shadowsocks defaults \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 fi \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 # Run ShadowsocksR in the background \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 /etc/init.d/shadowsocks start \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 clear \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo "Congratulations, ShadowsocksR install completed!" \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo -e "Server IP: \\033[41;37m $\{IP\} \\033[0m" \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo -e "Server Port: \\033[41;37m $\{shadowsocksport\} \\033[0m" \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo -e "Password: \\033[41;37m $\{shadowsockspwd\} \\033[0m" \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo -e "Protocol: \\033[41;37m auth_sha1_v4 \\033[0m" \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo -e "obfs: \\033[41;37m tls1.2_ticket_auth \\033[0m" \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo -e "Encryption Method: \\033[41;37m chacha20 \\033[0m" \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo "Welcome to visit:{\field{\*\fldinst{HYPERLINK "https://www.91yun.org/archives/2079"}}{\fldrslt \cf3 \ul \ulc3 https://www.91yun.org/archives/2079}}" \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo "If you want to change protocol & obfs, reference URL:" \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo "{\field{\*\fldinst{HYPERLINK "https://github.com/breakwa11/shadowsocks-rss/wiki/Server-Setup"}}{\fldrslt \cf3 \ul \ulc3 https://github.com/breakwa11/shadowsocks-rss/wiki/Server-Setup}}" \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo "Enjoy it!" \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo \
\'a0\'a0\'a0 else \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo "Shadowsocks install failed!" \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 install_cleanup \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 exit 1 \
\'a0\'a0\'a0 fi \
\} \
\
\
# Install cleanup \
function install_cleanup()\{ \
\'a0\'a0\'a0 cd $cur_dir \
\'a0\'a0\'a0 rm -f manyuser.zip \
\'a0\'a0\'a0 rm -rf shadowsocks-manyuser \
\'a0\'a0\'a0 rm -f libsodium-1.0.10.tar.gz \
\'a0\'a0\'a0 rm -rf libsodium-1.0.10 \
\} \
\
\
# Uninstall ShadowsocksR \
function uninstall_shadowsocks()\{ \
\'a0\'a0\'a0 printf "Are you sure uninstall ShadowsocksR? (y/n) " \
\'a0\'a0\'a0 printf "\\n" \
\'a0\'a0\'a0 read -p "(Default: n):" answer \
\'a0\'a0\'a0 if [ -z $answer ]; then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 answer="n" \
\'a0\'a0\'a0 fi \
\'a0\'a0\'a0 if [ "$answer" = "y" ]; then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 /etc/init.d/shadowsocks status > /dev/null 2>&1 \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 if [ $? -eq 0 ]; then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 /etc/init.d/shadowsocks stop \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 fi \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 checkos \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 if [ "$OS" == 'CentOS' ]; then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 chkconfig --del shadowsocks \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 else \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0 update-rc.d -f shadowsocks remove \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 fi \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 rm -f /etc/shadowsocks.json \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 rm -f /etc/init.d/shadowsocks \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 rm -rf /usr/local/shadowsocks \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo "ShadowsocksR uninstall success!" \
\'a0\'a0\'a0 else \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 echo "uninstall cancelled, Nothing to do" \
\'a0\'a0\'a0 fi \
\} \
\
\
# Install ShadowsocksR \
function install_shadowsocks()\{ \
\'a0\'a0\'a0 checkos \
\'a0\'a0\'a0 rootness \
\'a0\'a0\'a0 disable_selinux \
\'a0\'a0\'a0 pre_install \
\'a0\'a0\'a0 download_files \
\'a0\'a0\'a0 config_shadowsocks \
\'a0\'a0\'a0 install_ss \
\'a0\'a0\'a0 if [ "$OS" == 'CentOS' ]; then \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 firewall_set > /dev/null 2>&1 \
\'a0\'a0\'a0 fi \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 #check_datetime \
\'a0\'a0\'a0 install_cleanup \
\'a0\'a0\'a0\'a0\'a0\'a0\'a0 \
\} \
\
# Initialization step \
action=$1 \
[ -z $1 ] && action=install \
case "$action" in \
install) \
\'a0\'a0\'a0 install_shadowsocks \
\'a0\'a0\'a0 ;; \
uninstall) \
\'a0\'a0\'a0 uninstall_shadowsocks \
\'a0\'a0\'a0 ;; \
*) \
\'a0\'a0\'a0 echo "Arguments error! [$\{action\} ]" \
\'a0\'a0\'a0 echo "Usage: `basename $0` \{install|uninstall\}" \
\'a0\'a0\'a0 ;; \
esac \
}