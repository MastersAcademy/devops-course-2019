#!/bin/bash

if [ "$EUID" -ne 0 ]
then
  echo ' . . . permission denied, please run as root'
  exit
fi

docker build -t py/nginx . && docker run -p 80:80 py/nginx
 
