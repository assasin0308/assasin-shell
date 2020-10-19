#!/usr/bin/bash
echo echo "---------------------------- 使用root用户操作 -------------------------------" &&
echo "安装常用的扩展库工具" &&
yum install -y openssh-server git telnet java-11-openjdk wget htop glibc-devel pstree cmake ncurses-devel  zlib-devel perl flex bison net-tools  yum-config-manager yum-utils subversion ntpdate device-mapper-persistent-data lvm2 epel-release libxml2 libxml2-devel  openssl  openssl-devel  curl  curl-devel  libjpeg  libjpeg-devel  libpng  libpng-devel  freetype  freetype-devel  pcre  pcre-devel  libxslt  libxslt-devel  bzip2  bzip2-devel net-tools vim lrzsz tree screen lsof tcpdump nc mtr nmap libxml2 libxml2-dev libxslt-devel  gd-devel  GeoIP GeoIP-devel GeoIP-data g oniguruma oniguruma-develperftools libuuid-devel libblkid-devel libudev-devel fuse-devel libedit-devel libatomic_ops-devel gcc-c++ gcc+ gcc trousers-devel gettext gettext-devel gettext-common-devel openssl-devel libffi-devel bzip2  bzip2 bzip2-devel ImageMagick-devel libicu-devel sqlite-devel oniguruma oniguruma-devel

echo "安装完毕" &&
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" && 
echo "更新YUM源为阿里云源" && mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup && 
wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo && yum makecache fast && yum update -y  &&
echo "更新成功" &&
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" && 
echo "关闭&禁用防火墙" &&
systemctl status firewalld.service && systemctl disable firewalld.service && systemctl stop firewalld.service && ifconfig && 
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" && 



echo "---------------------------------- 安装Python虚拟环境  ---------------------------------" &&
# wget https://www.python.org/ftp/python/3.9.0/Python-3.9.0.tar.xz
# wget https://www.python.org/ftp/python/3.6.4/Python-3.6.4.tar.xz
# pip install virtualenv virtualenvwrapper  
# vim ~/.bashrc
# export WORKON_HOME=$HOME/.virtualenvs
# export VIRTUALENVWRAPPER_PYTHON=/usr/local/python3/bin/python3
# # 指定virtualenv的路径
# export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/python3/bin/virtualenv
# source /usr/local/python3/bin/virtualenvwrapper.sh

echo "修改Python-pip为阿里云源" && mkdir ~/.pip && touch ~/.pip/pip.conf && 
cat <<EOF > ~/.pip/pip.conf
[global]
index-url = https://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host=mirrors.aliyun.com
EOF
echo "修改完毕" &&
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" && 


echo "---------------------------------- 安装LNMP环境 NGINX,PHP 7.4,MySQL5.7 root & 19920308shibin  ---------------------------------" &&
wget -c http://mirrors.linuxeye.com/oneinstack-full.tar.gz && tar xzf oneinstack-full.tar.gz && ./oneinstack/install.sh --nginx_option 1 --php_option 9 --phpcache_option 1 --php_extensions zendguardloader,ioncube,fileinfo,imap,ldap,yaf,redis,memcached,memcache,mongodb,swoole --db_option 2 --dbinstallmethod 1 --dbrootpwd 19920308shibin

echo "LNMP安装完毕" &&
# Composer 阿里云镜像
composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ &&
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" && 





echo "---------------------------------- 安装TiDB v4.0.7  ---------------------------------" &&
wget http://download.pingcap.org/tidb-latest-linux-amd64.tar.gz && 
wget http://download.pingcap.org/tidb-latest-linux-amd64.sha256 && 
sha256sum -c tidb-latest-linux-amd64.sha256 && 
tar -xzf tidb-latest-linux-amd64.tar.gz && 
cd  /usr/local/tidb-v4.0.7-linux-amd64 && 
ll /usr/local/tidb-v4.0.7-linux-amd64/bin && 
echo " ----------------- 启动PD server,TiKV server ,TiDB server ----------- " &&
# 启动PD server
/usr/local/tidb-v4.0.7-linux-amd64/bin/pd-server  --data-dir=/usr/local/tidb-v4.0.7-linux-amd64/pd -metrics-addr="127.0.0.1:9090" --log-file=/usr/local/tidb-v4.0.7-linux-amd64/pd.log &  
# 启动TiKV server
/usr/local/tidb-v4.0.7-linux-amd64/bin/tikv-server --pd="0.0.0.0:2379" --data-dir=/usr/local/tidb-v4.0.7-linux-amd64/tikv --log-file=/usr/local/tidb-v4.0.7-linux-amd64/tikv.log &
# 启动TiDB server
/usr/local/tidb-v4.0.7-linux-amd64/bin/tidb-server --store=tikv --path="0.0.0.0:2379" --log-file=/usr/local/tidb-v4.0.7-linux-amd64/tidb.log &
# 终端登录 TIDB
# mysql -h 127.0.0.1 -P 4000 -u root -D test
# 添加账户并授予权限
# create user assasin@localhost identified by '123456';
# grant all  on *.* to assasin@localhost indentified by '123456';
# grant all privileges on *.* to assasin@'%' identified by '123456';
# grant all privileges on *.* to assasin@'%' identified by '123456' with grant option;
# FLUSH PRIVILEGES;

# 配置prometheus api
# curl -X POST -d '{"metric-storage":"http://{127.0.0.1:9090}"}' http://{127.0.0.1:2379}/pd/api/v1/config


echo " --------------------------------------- 启动 Success ------------------------------------- " &&
netstat -lntp && 
echo " ----------------- 配置TiDbB Dashboard,Nginx反向代理 127.0.0.1:2379 ----------- " &&
cat <<EOF > /usr/local/nginx/conf/vhost/tidb-dashboard.conf
upstream tidbserver { 
    server 127.0.0.1:2379;
}
server {
     listen   81;
     server_name  _;
     access_log /data/wwwlogs/access_nginx.log access_json;
     index  index.html index.htm;
     location / {
         proxy_pass   http://tidbserver;
     }
}
EOF
echo " TiDB Dashboard访问URL: http://0.0.0.0:2379/dashboard,代理后为 http://<ip>:81/dashboard " && 
echo " TiDB 集群状态访问URL:http://<ip>/pd/api/v1/config " && 
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" && 


echo " ------------------- 安装 grafana  -------------------------- " &&
wget https://dl.grafana.com/oss/release/grafana-5.4.3-1.x86_64.rpm && 
yum install -y  /usr/local/grafana-5.4.3-1.x86_64.rpm && 
# systemctl restart grafana-server
# grafana-cli plugins install alexanderzobnin-zabbix-app # 安装zabbix插件
# grafana-cli --pluginUrl https://github.com/cloudspout/cloudspout-button-panel/releases/download/7.0.2/cloudspout-button-panel.zip plugins install cloudspout-button-panel 
echo " -------------------  grafana Success  -------------------------- " &&



echo " ------------------- 安装 Prometheus https://prometheus.io/download/ -------------------------- " &&
wget https://github.com/prometheus/prometheus/releases/download/v2.14.0/prometheus-2.14.0.linux-amd64.tar.gz && 
tar zxvf prometheus-2.14.0.linux-amd64.tar.gz -C /usr/local/ && 
cat <<EOF > /etc/init.d/prometheus-server
#!/bin/bash
# auditd        Startup script
# chkconfig: 2345 14 87
# description: This is Startup script
# 服务器名
export SERVICE=prometheus
# 服务端口
export PORT=9090
# 基础目录
export BASE_DIR=/usr/local/prometheus-2.14.0.linux-amd64
. /etc/init.d/functions 
# 服务相关命令
start(){
    echo "${SERVICE} starting....."
    cd $BASE_DIR;nohup ${BASE_DIR}/prometheus --config.file=${BASE_DIR}/prometheus.yml --storage.tsdb.path=${BASE_DIR}/data &
    if [ $? -eq 0 ];then
        action "$SERVICE is starting" /bin/true
    else
        action "$SERVICE is starting" /bin/false
    fi
}
stop(){
    killall -9 $SERVICE
    if [ $? -eq 0 ];then
        action "$SERVICE is stoping" /bin/true
    else
        action "$SERVICE is stoping" /bin/false
    fi 
}
status(){
    if [ `ss -tunlp|grep ${PORT}|awk '{print $5}'|cut -d: -f2` = ${PORT} ];then
            echo "${SERVICE} is running....."
    else
            echo "${SERVICE} is stopping....."
    fi
}
case $1 in
start)
    start
    ;;
stop)
    stop
    ;;
restart)
    stop
    start
    ;;
status)
    status
    ;;
*)
   echo "$0 <start|stop|restart>"
esac
EOF
chmod +x /etc/init.d/prometheus-server && 
chkconfig --add prometheus-server && 
chkconfig --level 2345 prometheus-server on && 
/etc/init.d/prometheus-server start &&  
#/etc/init.d/prometheus-server restart &&  
#/etc/init.d/prometheus-server stop &&  
echo " -------------------------------  prometheus配置 prometheus.yml  ------------------------------- " && 
# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
# scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  # - job_name: 'prometheus'

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

  #   static_configs:
  #   - targets: ['0.0.0.0:9090']

  # - job_name: 'tidb'
  #   honor_labels: true  # 不要覆盖job和实例的label
  #   static_configs:
  #   - targets:
  #     - '0.0.0.0:10080'


  # - job_name: 'pd'
  #   honor_labels: true # 不要覆盖job和实例的label
  #   static_configs:
  #   - targets:
  #     - '0.0.0.0:2379'
  #     - '127.0.0.1:2379'

  # - job_name: 'tikv'
  #   honor_labels: true # 不要覆盖job和实例的label
  #   static_configs:
  #   - targets:
  #     - '0.0.0.0:20180'
  #     - '127.0.0.1:20180'



echo "----------------------------------- 安装NGINX 1.15   ---------------------------------" &&
# 直播必装模块
cd /usr/local/ && 
# wget https://github.com/arut/nginx-rtmp-module/archive/v1.2.1.tar.gz
# tar -zxvf v1.2.1.tar.gz && 
wget http://nginx.org/download/nginx-1.15.12.tar.gz && 
tar zxvf nginx-1.15.12.tar.gz && 
cd  /usr/local/nginx-1.15.12 && \
./configure --prefix=/usr/local/nginx --with-select_module --without-select_module --with-poll_module --without-poll_module \
--with-threads --with-file-aio --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_addition_module \
--with-http_xslt_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module \
--with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module  \
--with-http_secure_link_module --with-http_degradation_module --with-http_slice_module --with-mail --with-mail_ssl_module \
--with-stream --with-stream=dynamic --with-stream_ssl_module --with-stream_realip_module  \
--with-stream_ssl_preread_module --with-cpp_test_module --add-module=/usr/local/nginx-rtmp-module-1.2.1 && 
make && make install && 
/usr/local/nginx/sbin/nginx  && 
curl 127.0.0.1 && 
# 格式化nginx日志为json格式
log_format access_json '{"time_local": "$time_local", '
      '"status": $status, '
      '"request_method": "$request_method", '
      '"query_string": "$query_string", '
      '"script_name": "$fastcgi_script_name", '
      '"request_uri": "$request_uri", '
      '"document_root": "$document_root", '
      '"server_protocol": "$server_protocol", '
      '"request_scheme": "$scheme", '
      '"content_type": "$content_type", '
      '"server_protocol": "$server_protocol", '
      '"content_length": "$content_length", '
      '"remote_addr": "$remote_addr", '
      '"remote_user": "$remote_user", '
      '"remote_port": $remote_port, '
      '"server_port": $server_port, '
      '"server_name": "$server_name", '
      '"referer": "$http_referer", '
      '"request": "$request", '
      '"bytes": $body_bytes_sent, '
      '"agent": "$http_user_agent", '
      '"x_forwarded": "$http_x_forwarded_for", '
      '"up_addr": "$upstream_addr",'
      '"up_host": "$upstream_http_host",'
      '"upstream_time": "$upstream_response_time",'
      '"request_time": "$request_time"'
      ' }';
      
echo "---------------------- 安装NGINX 1.15 success    ------------------" &&


echo "安装Mysql5.7 用户名: root,密码:root" &&
wget -c http://mirrors.linuxeye.com/oneinstack-full.tar.gz && tar xzf oneinstack-full.tar.gz && ./oneinstack/install.sh --db_option 2 --dbinstallmethod 1 --dbrootpwd root &
systemctl start mysql && netstat -lntp &&
echo "安装Mysql5.7完毕" &&
# 添加账户并授予权限
# create user assasin@localhost identified by '123456';
# grant all  on *.* to assasin@localhost indentified by '123456';
# grant all privileges on *.* to assasin@'%' identified by '123456';
# grant all privileges on *.* to assasin@'%' identified by '123456' with grant option;
# FLUSH PRIVILEGES;
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" && 


echo "PHP版本选择对照" && 
echo " 1  ----> 5.3; 2  ----> 5.4; 3  ----> 5.5; 4  ----> 5.6; 5  ----> 7.0; 6  ----> 7.1; 7  ----> 7.2; 8  ----> 7.3 " && 
echo "安装PHP-7.2" &&
/usr/local/oneinstack/install.sh --php_option 7 --phpcache_option 1 --php_extensions zendguardloader,ioncube,sourceguardian,gmagick,yaf,fileinfo,imap,ldap,phalcon,redis,memcached,memcache,mongodb,swoole,xdebug,curl,calendar,bcmath,bz2,Core,ctype,date,dom,ereg,exif,filter,ftp,gettext,hash,iconv,igbinaryinotify,json,libxml,mbstring,mhash,mysql,mysqli,mysqlnd,openssl,pcntl,pcre,PDO,pdo_mysql,pdo_sqlite,Phar,posix,readline,Reflection,session,shmop,SimpleXML,sockets,SPL,sqlite3,standard,sysvmsg,sysvsem,sysvshmswoole,tokenizer,wddx,xml,xmlreader,xmlwriter,xslyaf,zip,zlib &&
echo "PHP-7.2安装完毕" && /usr/local/php/bin/php -m &&  
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" && 


echo "安装Docker-ce" && 
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo && 
yum makecache fast && 
yum -y install docker-ce &&
systemctl start docker && docker ps &&
echo "安装Docker-ce完毕" &&
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" && 


echo "安装Jenkins " && 
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo && 
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key && 
yum upgrade -y && 
yum install jenkins -y  &&
yum install java-1.8.0-openjdk-devel -y  &&  # Java 8版本
# yum install java-11-openjdk-devel -y  &&   # Java11版本
systemctl daemon-reload && 
systemclt start jenkins && 
systemclt status jenkins && 
echo "安装Jenkins完毕   http://<ip>:8080  " &&
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" && 



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
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" && 


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
# echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" && 


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
echo "同步完毕" && date && 
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" && 


######### 域名解析 #############################################################################
# vim /etc/resolv.conf
# nameserver 223.5.5.5
# nameserver 223.6.6.6
######### 域名解析 #############################################################################

echo "安装Nodejs" && cd /usr/local/  && 
wget https://nodejs.org/download/release/v8.14.1/node-v8.14.1-linux-arm64.tar.gz && tar -xvf node-v8.14.1-linux-arm64.tar.gz && 
ll /usr/local/node-v8.14.1-linux-arm64/bin &&
ln -s /usr/local/node-v8.14.1-linux-arm64/bin/node /usr/bin/node &&
ln -s /usr/local/node-v8.14.1-linux-arm64/bin/npm /usr/bin/npm && 
/usr/local/node-v8.14.1-linux-arm64/bin/npm config set registry https://registry.npm.taobao.org  && 
npm install cnpm -g && 
ln -s /usr/local/node-v8.14.1-linux-arm64/bin/cnpm /usr/bin/cnpm && 
npm install nrm -g && 
ln -s /usr/local/node-v8.14.1-linux-arm64/bin/nrm /usr/bin/nrm && 
npm config get registry &&
nrm ls && 
echo "nodejs安装完毕"
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" && 


echo "Redis 5.0.9" &&
cd /usr/local/ &&
wget http://download.redis.io/releases/redis-5.0.9.tar.gz && tar -xvf redis-5.0.9.tar.gz && cd /usr/local/redis-5.0.9 && make && make test && cd /usr/local &&
#echo "启动Redis..........." &&
#/usr/local/redis-5.0.9/src/redis-server ./redis.conf
echo "Redis 安装完毕" &&
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" && 


############################ Elasticsearch & Logstash & Kibana ############################################
# elasticsearch
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch && 
cat <<EOF >/etc/yum.repos.d/elasticsearch.repo
[elasticsearch]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=0
autorefresh=1
type=rpm-md
EOF
yum install --enablerepo=elasticsearch elasticsearch && 
systemctl daemon-reload && 
systemctl start elasticsearch &&
systemctl status elasticsearch &&
systemctl restart elasticsearch &&
# /etc/elasticsearch/elasticsearch.yml
# http.cors.enabled: true 
# http.cors.allow-origin: "*"
# 测试
curl 127.0.0.1:9200

# logstash
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cat <<EOF >/etc/yum.repos.d/logstash.repo
[logstash-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
yum install logstash -y && 
systemctl daemon-reload && 
systemctl start logstash &&
systemctl status logstash &&
systemctl restart logstash 

# /etc/logstash.conf
# input {
#     file {
#       path => "/apps/tomcat/logs/tomcat_access_log.*.log"
#       type => "tomcat-access-log-101"
#       start_position => "beginning"
#       stat_interval => "2"
#       codec => "json"
#    }
# }

# output {
#     elasticsearch {
#        hosts => ["192.168.2.101:9200"]
#        index => "logstash-tomcat-access-log-101-%{++YYYY.MM.dd}"
#     }
#     file {
#         path => "/tmp/tomcat.txt"
#     }
# }
# kibana
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch && 
cat <<EOF >/etc/yum.repos.d/kibana.repo
[kibana-7.x]
name=Kibana repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
yum install kibana -y && 
systemctl daemon-reload && 
systemctl start kibana &&
systemctl status kibana &&
systemctl restart kibana &&

############################ Elasticsearch & Logstash & Kibana ############################################

echo "################################################################## Congratulations #######################################################################" 

