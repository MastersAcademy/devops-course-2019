#!/bin/bash

if [ "$EUID" -ne 0 ]
then
    echo ' . . . permission denied, please run as root'
    exit
fi

imageName='py/nginx'

docker build -t ${imageName} .
containerId=$(docker run -p 8181:80 -d $imageName)

echo -e '\n . . . curl to 127.0.0.1:8181\n'

curl 127.0.0.1:8181

echo -e '\n . . . remove container and image\n'

docker container stop ${containerId}
docker rm ${containerId}
docker rmi -f ${imageName}
