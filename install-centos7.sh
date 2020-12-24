#!/usr/bin/bash
echo echo "---------------------------- 使用root用户操作 -------------------------------" &&
echo "安装常用的扩展库工具" &&
yum install -y  git telnet java-11-openjdk composer htop glibc-devel pstree cmake ncurses-devel  zlib-devel perl flex bison net-tools  yum-config-manager yum-utils subversion ntpdate m4 unixODBC  unixODBC-devel device-mapper-persistent-data lvm2 epel-release libxml2 libxml2-devel  openssl  openssl-devel  curl  curl-devel  libjpeg  libjpeg-devel  libpng  libpng-devel  freetype  freetype-devel  pcre  pcre-devel  libxslt  libxslt-devel  bzip2  bzip2-devel net-tools vim lrzsz tree screen lsof tcpdump nc mtr nmap libxml2 libxml2-dev libxslt-devel  gd-devel  GeoIP GeoIP-devel GeoIP-data g oniguruma oniguruma-develperftools libuuid-devel libblkid-devel libudev-devel fuse-devel libedit-devel libatomic_ops-devel gcc-c++ gcc+ gcc trousers-devel gettext gettext-devel gettext-common-devel openssl-devel libffi-devel bzip2  bzip2 bzip2-devel ImageMagick-devel libicu-devel sqlite-devel oniguruma oniguruma-devel

composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

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
# apt-get install build-essential python-dev python-setuptools python-pip python-smbus libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev zlib1g-dev libc6-dev libsqlite3-dev tk-dev install libssl-dev openssl libffi-dev
# wget https://www.python.org/ftp/python/3.9.0/Python-3.9.0.tar.xz
# wget https://www.python.org/ftp/python/3.6.4/Python-3.6.4.tar.xz
# wget https://www.python.org/ftp/python/3.7.9/Python-3.7.9.tar.xz
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





echo "---------------------------------- 安装TiDB v4.0.7  ----------------------------------------------" &&
wget http://download.pingcap.org/tidb-latest-linux-amd64.tar.gz && 
wget http://download.pingcap.org/tidb-latest-linux-amd64.sha256 && 
sha256sum -c tidb-latest-linux-amd64.sha256 && 
tar -xzf tidb-latest-linux-amd64.tar.gz && 
cd  /usr/local/tidb-v4.0.7-linux-amd64 && 
ll /usr/local/tidb-v4.0.7-linux-amd64/bin && 
echo " ----------------- 启动PD server,TiKV server ,TiDB server ------------------------------------- " &&
# 启动PD server
/usr/local/tidb-v4.0.7-linux-amd64/bin/pd-server  --data-dir=/usr/local/tidb-v4.0.7-linux-amd64/pd -metrics-addr="127.0.0.1:9090" --log-file=/usr/local/tidb-v4.0.7-linux-amd64/pd.log &  
# 启动TiKV server
/usr/local/tidb-v4.0.7-linux-amd64/bin/tikv-server --pd="0.0.0.0:2379" --data-dir=/usr/local/tidb-v4.0.7-linux-amd64/tikv --log-file=/usr/local/tidb-v4.0.7-linux-amd64/tikv.log &
# 启动TiDB server
/usr/local/tidb-v4.0.7-linux-amd64/bin/tidb-server --store=tikv --path="0.0.0.0:2379" --log-file=/usr/local/tidb-v4.0.7-linux-amd64/tidb.log &
# 终端登录 TIDB
# mysql -h 127.0.0.1 -P 4000 -u root -D test
# 添加账户并授予权限
# create user root@localhost identified by '19920308shibin';
# grant all privileges on *.* to root@localhost indentified by '19920308shibin';
# grant all privileges on *.* to root@'%' identified by '19920308shibin';
# grant all privileges on *.* to root@'%' identified by '19920308shibin' with grant option;
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


echo " ------------------- 安装 grafana  ------------------------------------------ " &&
wget https://dl.grafana.com/oss/release/grafana-5.4.3-1.x86_64.rpm   && 
yum install -y  /usr/local/grafana-5.4.3-1.x86_64.rpm  && 
# systemctl restart grafana-server
# grafana-cli plugins install grafana-piechart-panel
# grafana-cli plugins install alexanderzobnin-zabbix-app # 安装zabbix插件
# grafana-cli --pluginUrl https://github.com/cloudspout/cloudspout-button-panel/releases/download/7.0.2/cloudspout-button-panel.zip plugins install cloudspout-button-panel 
echo " -------------------  grafana Success  ------------------------------------- " &&



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



echo "----------------------------------- 安装Nginx 1.15   ---------------------------------" &&
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


echo "安装PostgreSQL: The World's Most Advanced Open Source Relational Database " && 
# Install the repository RPM:
sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
# Install PostgreSQL:
sudo yum install -y postgresql13-server
# Optionally initialize the database and enable automatic start:
sudo /usr/pgsql-13/bin/postgresql-13-setup initdb
sudo systemctl enable postgresql-13
sudo systemctl start postgresql-13
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" && 


echo "PHP版本选择对照" && 
echo " 1  ----> 5.3; 2  ----> 5.4; 3  ----> 5.5; 4  ----> 5.6; 5  ----> 7.0; 6  ----> 7.1; 7  ----> 7.2; 8  ----> 7.3 " && 
echo "安装PHP-7.2" &&
/usr/local/oneinstack/install.sh --php_option 7 --phpcache_option 1 --php_extensions zendguardloader,ioncube,sourceguardian,gmagick,yaf,fileinfo,imap,ldap,phalcon,redis,memcached,memcache,mongodb,swoole,xdebug,curl,calendar,bcmath,bz2,Core,ctype,date,dom,ereg,exif,filter,ftp,gettext,hash,iconv,igbinaryinotify,json,libxml,mbstring,mhash,mysql,mysqli,mysqlnd,openssl,pcntl,pcre,PDO,pdo_mysql,pdo_sqlite,Phar,posix,readline,Reflection,session,shmop,SimpleXML,sockets,SPL,sqlite3,standard,sysvmsg,sysvsem,sysvshmswoole,tokenizer,wddx,xml,xmlreader,xmlwriter,xslyaf,zip,zlib &&
echo "PHP-7.2安装完毕" && /usr/local/php/bin/php -m &&  
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" && 


echo "安装Docker-ce" && 
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo && 
yum makecache fast &&  yum -y install docker-ce docker-compose  && systemctl enable docker && systemctl  start docker && docker ps &&
echo "安装Docker-ce完毕" &&
vim /etc/docker/daemon.json
{
  "registry-mirrors": ["https://hr1upp6v.mirror.aliyuncs.com"]
}
sudo systemctl daemon-reload && systemctl restart docker
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" && 


echo "安装Jenkins " && 
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo && 
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key && 
yum upgrade -y &&  yum install jenkins -y  &&
yum install java-1.8.0-openjdk-devel -y  &&  # Java 8版本
# yum install java-11-openjdk-devel -y  &&   # Java11版本
systemctl daemon-reload &&  systemctl start jenkins && systemctl status jenkins && 
echo "安装Jenkins完毕   http://<ip>:8080  " &&  http://<ip>:8080/restart
[ update ]
http://mirrors.shu.edu.cn/jenkins/updates/current/update-center.json
https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json
1. 全局安全配置-> 代理
2. 添加slave节点
3. 下载agent.jar > /usr/local/jenkins-slave/
4. echo 68870fc3f0e1558c0ee684f7a4306275f2ccd7a7e3e708012c810e516d751d5f > s/usr/local/jenkins-slave/
nohup  java -jar agent.jar -jnlpUrl http://192.168.32.128:8080/computer/slave/jenkins-agent.jnlp -secret @secret-file -workDir "/usr/local/jenkins-slave" & 
5.构建Maven项目
5.1 安装Maven:
wget  https://mirror.bit.edu.cn/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
tar xzvf apache-maven-3.6.3-bin.tar.gz
vim /etc/profile
export M2_HOME=/usr/local/apache-maven-3.6.3
export PATH=$PATH:$M2_HOME/bin
source /etc/profile/profile

mvn --version

5.2 Maven项目:  https://github.com/initcron/mvn-test.git
5.3 mvn指令:
[ mvn clean: 清除缓存 ]
[ mvn install: 打包 ]
[ mvn test: 单元测试 ]
5.4 jenkins自动构建:

5.5 提交代码自动触发构建
安装插件: gitlab hook 
配置gitlab仓库
   
6 jenkins-pipline
安装插件: 关于pipline基础插件
7 参数化构建

8 远程构建
8.1 参数化构建之不带参数
curl -s -u assasin:19920308shibin -X POST "http://192.168.32.128:8080/job/diy-maven_TEST/buildWithParameters?token=testabc"
8.2 参数化构建之带参数
curl -s -u assasin:19920308shibin -X POST "http://192.168.32.128:8080/job/diy-maven_TEST/buildWithParameters?token=testabc" -d bildStatus=off
8.3 非参数化构建
curl -s -u assasin:19920308shibin -X POST "http://192.168.32.128:8080/job/diy-maven_TEST/build?token=testabc"
8.4 获取构建结果
curl -s -u assasin:19920308shibin -X POST "http://192.168.32.128:8080/job/diy-maven_TEST/lastBuild/api/json?token=testabc"
curl -s -u assasin:19920308shibin -X POST "http://192.168.32.128:8080/job/diy-maven_TEST/lastBuild/api/json?token=testabc" | grep -Po '"result":".*?"'
curl -s -u assasin:19920308shibin -X POST "http://192.168.32.128:8080/job/diy-maven_TEST/lastBuild/api/json?token=testabc" | grep -Po '"result":".*?"' | awk -F : '{print $2}'

echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" && 

# gitlab 安装:
wget https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/gitlab-ce-10.7.3-ce.0.el7.x86_64.rpm &&  yum install gitlab-ce-10.7.3-ce.0.el7.x86_64.rpm -y &&
gitlab-ctl reconfigure
gitlab-ctl restart
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" && 


# SonarQube6.7 安装:
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-6.7.7.zip && 
wget https://repo1.maven.org/maven2/org/codehaus/sonar/runner/sonar-runner-dist/2.4/sonar-runner-dist-2.4.zip && 
vim  /usr/local/sonar-runner-2.4/conf/sonar-runner.properties
cat <<EOF  > /usr/local/sonar-runner-2.4/conf/sonar-runner.properties
#----- Default SonarQube server
sonar.host.url=http://<ip>:9000

#----- PostgreSQL
#sonar.jdbc.url=jdbc:postgresql://localhost/sonar

#----- MySQL
sonar.jdbc.url=jdbc:mysql://localhost:3306/sonar?useUnicode=true&amp;characterEncoding=utf8

#----- Oracle
#sonar.jdbc.url=jdbc:oracle:thin:@localhost/XE

#----- Microsoft SQLServer
#sonar.jdbc.url=jdbc:jtds:sqlserver://localhost/sonar;SelectMethod=Cursor

#----- Global database settings
sonar.jdbc.username=sonar
sonar.jdbc.password=sonar

#----- Default source code encoding
#sonar.sourceEncoding=UTF-8

#----- Security (when 'sonar.forceAuthentication' is set to 'true')
sonar.login=admin
sonar.password=admin
EOF


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
yum install -y kubelet kubeadm kubectl && systemctl enable kubelet && systemctl start kubelet && 
echo "安装Kubernetes完毕" &&
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" && 


echo "安装MongoDB " && 
cat <<EOF > /etc/yum.repos.d/mongodb-org.repo
[mongodb-org-4.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc
EOF
# yum install -y mongodb-org-4.4.1 mongodb-org-server-4.4.1 mongodb-org-shell-4.4.1 mongodb-org-mongos-4.4.1 mongodb-org-tools-4.4.1
yum install -y mongodb-org && netstat -lntp
systemctl start mongodb && 
echo "安装MongoDB完毕" &&
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" && 


echo "同步时间" &&
# echo "*/20 * * * * /usr/sbin/ntpdate -u ntp.api.bz >/dev/null &" >> /var/spool/cron/root
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
vim /etc/resolv.conf
nameserver 223.5.5.5
nameserver 223.6.6.6
nameserver 8.8.8.8
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
docker run -itd --privileged=true -p 6380:6379 --restart always -v /usr/local/redis-5.0.9/redis.conf:/etc/redis/redis.conf -v /usr/local/redis-5.0.9/data:/data --name docker-redis redis:6.0 redis-server /etc/redis/redis.conf --requirepass '123456' --bind 0.0.0.0 --daemonize no --protected-mode yes --appendonly no
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------" && 


############################ Elasticsearch & Logstash & Kibana & Filebeats ############################################
# elasticsearch
docker pull elasticsearch
docker run -itd --name elasticsearch -v /elasticsearch/data:/usr/share/elasticsearch/data -v /elasticsearch/conf:/etc/elasticsearch -p 9200:9200 elasticsearch 
# ----------------
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
yum install --enablerepo=elasticsearch elasticsearch -y  && 
systemctl daemon-reload && 
systemctl start elasticsearch &&
systemctl status elasticsearch &&
systemctl restart elasticsearch &&
# /etc/elasticsearch/elasticsearch.yml
http.cors.enabled: true 
http.cors.allow-origin: "*"
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
 input {
    file {
      path => "/apps/tomcat/logs/tomcat_access_log.*.log"
      type => "tomcat-access-log-101"
      start_position => "beginning"
      stat_interval => "2"
      codec => "json"
   }
}

output {
    elasticsearch {
       hosts => ["192.168.2.101:9200"]
       index => "logstash-tomcat-access-log-101-%{++YYYY.MM.dd}"
    }
    file {
        path => "/tmp/tomcat.txt"
    }
}


# test logstash.conf
# /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/systemlog.conf -t
# /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/systemlog.conf  --config.reload.automatic
# /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/nginx128.conf  --path.data=/var/lib/logstash/


# kibana
docker pull kibana
docker run -itd --name kibana --link elasticsearch:elasticsearch -p 5601:5601 kibana
# ---------------------
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

# Filebeat
yum install filebeat -y && 
# Heartbeat
yum install heartbeat-elastic && 
systemctl enable heartbeat-elastic  
############################ Elasticsearch & Logstash & Kibana ############################################


############################  Zabbix 监控系统   ############################################
docker pull zabbix/zabbix-java-gateway

docker pull zabbix/zabbix-server-mysql

docker pull zabbix/zabbix-web-nginx-mysql

docker pull mysql:5.7

docker run --name zabbix-java-gateway -t -d zabbix/zabbix-java-gateway:latest

docker run --name mysql-server -itd -p 3307:3306 -e MYSQL_DATABASE="zabbix" -e MYSQL_USER="zabbix" -e MYSQL_PASSWORD="zabbix" -e MYSQL_ROOT_PASSWORD="zabbix"  mysql:5.7 --character-set-server=utf8 --collation-server=utf8_bin

docker run --name zabbix-server-mysql -itd -e DB_SERVER_HOST="192.168.80.157" -e DB_SERVER_PORT=3307 -e MYSQL_DATABASE="zabbix" -e MYSQL_USER="zabbix" -e MYSQL_PASSWORD="zabbix" -e MYSQL_ROOT_PASSWORD="zabbix" -e ZBX_JAVAGATEWAY="zabbix-java-gateway" --link mysql-server:mysql --link zabbix-java-gateway:zabbix-java-gateway -p 10051:10051  zabbix/zabbix-server-mysql:latest

docker run --name zabbix-web-nginx-mysql -t -e PHP_TZ="Asia/Shanghai" -e DB_SERVER_HOST="192.168.80.157" -e DB_SERVER_PORT=3307 -e MYSQL_DATABASE="zabbix" -e MYSQL_USER="zabbix" -e MYSQL_PASSWORD="zabbix" -e MYSQL_ROOT_PASSWORD="zabbix" --link mysql-server:mysql --link zabbix-server-mysql:zabbix-server -p 8080:8080 -d zabbix/zabbix-web-nginx-mysql:latest


############################ ---------------- ############################################


############################ API Umbrella   ############################################
curl https://bintray.com/nrel/api-umbrella-el7/rpm | sudo tee /etc/yum.repos.d/api-umbrella.repo 
yum install api-umbrella -y 
/etc/init.d/api-umbrella start

############################ Rabbitmq 3.7.8   ############################################
# http://erlang.org/download/
wget http://erlang.org/download/otp_src_21.1.tar.gz
tar -zxvf otp_src_21.1.tar.gz  
./configure --prefix=/usr/local/erlang && make && make install
# 配置环境变量
vim /etc/profile
PATH=$PATH:/usr/local/erlang/bin
source /etc/profile

# http://www.rabbitmq.com/which-erlang.html  && http://www.rabbitmq.com/install-generic-unix.html
wget https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.8/rabbitmq-server-generic-unix-3.7.8.tar.xz
tar -xvf rabbitmq-server-generic-unix-3.7.8.tar.xz

# 配置环境变量
vim /etc/profile
PATH=$PATH:/usr/local/rabbitmq_server-3.7.8/sbin
source /etc/profile
# 插件管理
rabbitmq-plugins list
# 添加web管理插件
rabbitmq-plugins enable rabbitmq_management   

# 后台启动rabbitmq服务
rabbitmq-server -detached
# stop server
rabbitmqctl stop

# 用户管理：
# 添加用户： rabbitmqctl add_user username password
# 删除用户： rabbitmqctl delete_user username
# 修改密码： rabbitmqctl change_password username newpassword
# 设置用户角色： rabbitmqctl set_user_tags username tag
# 列出用户： rabbitmqctl list_users
# 权限管理：
# 列出所有用户权限： rabbitmqctl list_permissions
# 查看制定用户权限： rabbitmqctl list_user_permissions username
# 清除用户权限： rabbitmqctl clear_permissions [-p vhostpath] username
# 设置用户权限： rabbitmqctl set_permissions [-p vhostpath] username conf write read
#                           conf: 一个正则匹配哪些资源能被该用户访问
#                           write：一个正则匹配哪些资源能被该用户写入
#                           read：一个正则匹配哪些资源能被该用户读取

echo "################################################################## Congratulations #######################################################################" 

