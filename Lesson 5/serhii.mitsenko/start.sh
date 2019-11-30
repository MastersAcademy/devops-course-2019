#!/bin/bash
if [ "$EUID" -ne 0 ]
   then echo "Please run as root"
fi

docker build -t test-image .
docker run -p 8181:80 -d test-image
curl 127.0.0.1:8181
docker kill $(docker ps -q)
