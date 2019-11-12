#!/bin/bash

packed=nginx

if apt list --installed |grep $packed
then
echo `nginx -v`
apt purge -y nginx*
echo "The $packed remove"
else
echo "The packed $packed not installed in the system"
fi

