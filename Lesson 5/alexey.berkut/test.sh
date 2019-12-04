#!/bin/bash

if [[ "$EUID" != 0 ]]
then
	echo "Please run as root";
	exit 0;
fi

systemctl restart docker.service;
docker build -t lesson5/nginx ./;
docker run -d -p 127.0.0.1:80:80 lesson5/nginx;
curl -X GET 127.0.0.1:80;
processId=`docker ps | grep "lesson5/nginx" | awk '{print $1}'`;
docker stop $processId;
exit 0;

