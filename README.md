# nginx+php-fpm+mysql+registry by docker-compose

Quickly build common publishing environments by docker-compose.

## usage
```
chmod +x build_env.sh;./build.sh
```

## directory structure

```

├── conf  
│   ├── mysql  
│   │   └── my.cnf #mysql config  
│   └── nginx  
│       ├── conf.d #nginx server config  
│       │   └── default.conf   
│       └── nginx.conf #nginx config  
├── db  #mysql data  
├── docker-compose.yml 
├── door #share dir 
├── log  
│   ├── mysql  
│   ├── nginx  
│   └── php  
├── registry  
│   ├── certs  #retistry certs  
│   └── data   #retistry data  
└── www  #website wwwroot

```

## build docker
```
docker-compose up -d
```

## build secure registry

See:  
[Use docker-compose build Secure Registry](http://wyq.me/blog/2019/01/22/%E4%BD%BF%E7%94%A8docker-compose%E5%BF%AB%E9%80%9F%E6%90%AD%E5%BB%BA%E5%AE%89%E5%85%A8%E7%9A%84%E7%A7%81%E6%9C%89secure-registry/)
