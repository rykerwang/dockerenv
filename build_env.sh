#!/bin/bash

echo "##########################################"
echo "#   nginx+php-fpm+mysql+registry env..   #"
echo "#----------------------------------------#"
echo "#       support docker:18.09.1+          #"
echo "#----------------------------------------#"
echo "# nginx:1.15.8                           #"
echo "# php-fpm:7.3.1                          #"
echo "# mysql:5.7                              #"
echo "# registry:2.7.1                         #"
echo "#----------------------------------------#"
echo "# blog: http://wyq.me                    #"
echo "# github: https://github.com/rykerwang   #"
echo "##########################################"



echo "##########################################

mkdir ./conf 1>/dev/null 2>/dev/null
mkdir ./conf/mysql 1>/dev/null 2>/dev/null
mkdir ./conf/nginx 1>/dev/null 2>/dev/null
mkdir ./conf/nginx/conf.d 1>/dev/null 2>/dev/null
mkdir ./db 1>/dev/null 2>/dev/null
mkdir ./door 1>/dev/null 2>/dev/null
mkdir ./log 1>/dev/null 2>/dev/null
mkdir ./log/mysql 1>/dev/null 2>/dev/null
mkdir ./log/nginx 1>/dev/null 2>/dev/null
mkdir ./log/php 1>/dev/null 2>/dev/null
mkdir ./registry 1>/dev/null 2>/dev/null
mkdir ./registry/data 1>/dev/null 2>/dev/null
mkdir ./registry/certs 1>/dev/null 2>/dev/null
mkdir ./www 1>/dev/null 2>/dev/null

cat > ./conf/mysql/my.cnf <<EOF
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL
symbolic-links=0
!includedir /etc/mysql/conf.d/
EOF


cat > ./conf/nginx/nginx.conf <<EOF
user  nginx;
worker_processes  4;
#worker_cpu_affinity 01 10 01 10;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
    worker_connections  10240;
    use epoll;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;
    sendfile        on;
    keepalive_timeout  65;
    gzip on;
    gzip_buffers 4 16k;
    gzip_http_version 1.0;
    gzip_comp_level 2;
    gzip_types text/plain application/x-javascript text/css application/xml;
    gzip_proxied expired no-cache no-store private auth;
    large_client_header_buffers 4 32k;
    client_max_body_size 100m;
    include /etc/nginx/conf.d/*.conf;
}
EOF

cat > ./conf/nginx/conf.d/default.conf <<EOF

server {
    #server_name domain.com;
    error_log  /var/log/nginx/default.error.log warn;
    access_log  /var/log/nginx/default.access.log;
    charset utf-8;
    root /var/www;
    index index.php;
    location / {
        try_files $uri $uri/ /index.php$is_args$args;
    }

    location ~ ^/assets/.*\.php$ {
        deny all;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_pass php:9000;
        try_files $uri =404;
    }

    location ~* /\. {
        deny all;
    }
}
EOF

docker-compose up -d