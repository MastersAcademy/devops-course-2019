#!/bin/bash

if [[ $(id -u) -ne 0 ]]; then
  echo "Please run script as root"
  exit 1	
fi

image_name='web_nginx'

docker-compose build
docker-compose up -d

echo -e '\033[0;32m \n'
docker-compose ps

echo -e '\n check NGINX  . . . \033[0m \n'
curl 127.0.0.1:8181

echo -e '\n \033[0;32m stop and remove container  . . . \033[0m \n'
docker-compose stop
docker-compose down
docker rmi -f $image_name
