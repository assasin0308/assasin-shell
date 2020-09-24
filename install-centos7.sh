#!/usr/bin/bash
echo echo "---------------------------- 使用root用户操作 -------------------------------" &&
echo "安装常用的扩展库工具" &&
yum install -y openssh-server git wget htop yum-utils subversion ntpdate device-mapper-persistent-data lvm2 epel-release libxml2 libxml2-devel  openssl  openssl-devel  curl  curl-devel  libjpeg  libjpeg-devel  libpng  libpng-devel  freetype  freetype-devel  pcre  pcre-devel  libxslt  libxslt-devel  bzip2  bzip2-devel net-tools vim lrzsz tree screen lsof tcpdump nc mtr nmap libxml2 libxml2-dev libxslt-devel  gd-devel  GeoIP GeoIP-devel GeoIP-data g oniguruma oniguruma-develperftools libuuid-devel libblkid-devel libudev-devel fuse-devel libedit-devel libatomic_ops-devel gcc-c++ gcc+ gcc trousers-devel gettext gettext-devel gettext-common-devel openssl-devel libffi-devel bzip2  bzip2 bzip2-devel ImageMagick-devel libicu-devel sqlite-devel oniguruma oniguruma-devel
echo "安装完毕" &&
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" 
echo "更新YUM源为阿里云源" &&
wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo && yum makecache fast && yum update -y  &&
echo "更新成功" &&
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" 
echo "关闭&禁用防火墙" &&
systemctl status firewalld.service && systemctl disable firewalld.service && systemctl stop firewalld.service && ifconfig && 
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" 

echo "Redis 5.0.9" &&
cd /usr/local/ &&
wget http://download.redis.io/releases/redis-5.0.9.tar.gz && tar -xvf redis-5.0.9.tar.gz && cd /usr/local/redis-5.0.9 && make && make test && cd /usr/local &&
echo "Redis 安装完毕" &&
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" 


# php版本
# 1  ----> 5.3 
# 2  ----> 5.4 
# 3  ----> 5.5 
# 4  ----> 5.6
# 5  ----> 7.0 
# 6  ----> 7.1 
# 7  ----> 7.2
# 8  ----> 7.3 
echo "安装PHP-7.2" &&
/usr/local/oneinstack/install.sh --php_option 7 --phpcache_option 1 --php_extensions zendguardloader,ioncube,sourceguardian,imagick,gmagick,yaf,fileinfo,imap,ldap,phalcon,redis,memcached,memcache,mongodb,swoole,xdebug,curl,calendar,bcmath,bz2,Core,ctype,date,dom,ereg,exif,filter,ftp,gettext,hash,iconv,igbinaryinotify,json,libxml,mbstring,mhash,mysql,mysqli,mysqlnd,openssl,pcntl,pcre,PDO,pdo_mysql,pdo_sqlite,Phar,posix,readline,Reflection,session,shmop,SimpleXML,sockets,SPL,sqlite3,standard,sysvmsg,sysvsem,sysvshmswoole,tokenizer,wddx,xml,xmlreader,xmlwriter,xslyaf,zip,zlib
echo "PHP-7.2安装完毕" && /usr/local/php/bin/php -m &&  
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" 


echo "安装Mysql5.7 用户名: root,密码:root" &&
wget -c http://mirrors.linuxeye.com/oneinstack-full.tar.gz && tar xzf oneinstack-full.tar.gz && ./oneinstack/install.sh --db_option 2 --dbinstallmethod 1 --dbrootpwd root &&
systemctl start mysql && netstat -lntp &&
echo "安装Mysql5.7完毕" &&
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" 

echo "安装Docker-ce" && 
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo && 
yum makecache fast && 
yum -y install docker-ce &&
systemctl start docker && docker ps &&
echo "安装Docker-ce完毕" &&
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" 


echo "安装Kubernetes" && 
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
setenforce 0 && 
yum install -y kubelet kubeadm kubectl && 
systemctl enable kubelet && systemctl start kubelet && 
echo "安装Kubernetes完毕" &&
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" 


# echo "安装MongoDB " && 
# cat <<EOF > /etc/yum.repos.d/mongodb-org.repo
# [mongodb-org] 
# name = MongoDB Repository
# baseurl = https://mirrors.aliyun.com/mongodb/yum/redhat/$releasever/mongodb-org/3.6/x86_64/
# gpgcheck = 1 
# enabled = 1 
# gpgkey = https：// www.mongodb.org/static/pgp/server-3.6.asc
# EOF
# yum install -y mongodb && netstat -lntp
# systemctl start mongodb && 
# echo "安装MongoDB完毕" &&
# echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" 



echo "修改Python-pip为阿里云源" && 
cat <<EOF > ~/.pip/pip.conf
[global]
index-url = https://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host=mirrors.aliyun.com
EOF
echo "修改完毕" &&
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" 


echo "同步时间" &&
cat <<EOF > /etc/ntp.conf
driftfile  /var/lib/ntp/drift
pidfile   /var/run/ntpd.pid
logfile /var/log/ntp.log
restrict    default kod nomodify notrap nopeer noquery
restrict -6 default kod nomodify notrap nopeer noquery
restrict 127.0.0.1
server 127.127.1.0
fudge  127.127.1.0 stratum 10
server ntp.aliyun.com iburst minpoll 4 maxpoll 10
restrict ntp.aliyun.com nomodify notrap nopeer noquery

server ntp1.cloud.aliyuncs.com iburst minpoll 4 maxpoll 10
restrict ntp1.cloud.aliyuncs.com nomodify notrap nopeer noquery
server ntp2.cloud.aliyuncs.com iburst minpoll 4 maxpoll 10
restrict ntp2.cloud.aliyuncs.com nomodify notrap nopeer noquery
server ntp3.cloud.aliyuncs.com iburst minpoll 4 maxpoll 10
restrict ntp3.cloud.aliyuncs.com nomodify notrap nopeer noquery
server ntp4.cloud.aliyuncs.com iburst minpoll 4 maxpoll 10
restrict ntp4.cloud.aliyuncs.com nomodify notrap nopeer noquery
server ntp5.cloud.aliyuncs.com iburst minpoll 4 maxpoll 10
restrict ntp5.cloud.aliyuncs.com nomodify notrap nopeer noquery
server ntp6.cloud.aliyuncs.com iburst minpoll 4 maxpoll 10
restrict ntp6.cloud.aliyuncs.com nomodify notrap nopeer noquery
EOF
echo "同步完毕" && crontab -l  && date && 
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" 


echo "安装Nodejs" && cd /usr/local/ && 
wget https://nodejs.org/download/release/v8.14.1/node-v8.14.1-linux-arm64.tar.gz && node-v8.14.1-linux-arm64.tar.gz && 
ln -s /usr/local/node-v8.14.1-linux-arm64/bin/node /usr/bin/node &&
ln -s /usr/local/node-v8.14.1-linux-arm64/bin/npm /usr/bin/npm && 
/usr/local/node-v8.14.1-linux-arm64/bin/npm config set registry https://registry.npm.taobao.org  && 
npm config get registry &&
echo "nodejs安装完毕"
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" 


echo "安装Java-11" &&
yum install -y java-11-openjdk && java -version &&
echo "java安装完毕"
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" 


echo "################################################################## Congratulations #######################################################################" 

