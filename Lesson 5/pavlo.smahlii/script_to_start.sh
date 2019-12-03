#!/bin/bash

if [ "$EUID" -ne 0 ]
	then
		echo 'run as root'
	exit
fi

imageName='ubuntu_test:18.04'

docker build -t ${imageName} .
containerId=$(docker run -p 8181:80 -d $imageName)
curl 127.0.0.1:8181
docker container stop ${containerId}
docker rm ${containerId}
docker rmi -f ${imageName}
