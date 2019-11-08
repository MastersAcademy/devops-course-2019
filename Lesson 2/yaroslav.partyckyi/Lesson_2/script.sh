#!/bin/bash

function checkNginx {
    echo -e "\n . . . nginx found:"
    nginx -v
}

echo -e "\n . . . running script"
echo -e "\n . . . list of programs:"

apt list --installed

if command -v nginx
then 
    checkNginx

    apt remove nginx nginx-common -y
    apt purge nginx nginx-common -y
    apt autoremove -y

    echo -e  "\n . . . nginx has been deleted"
else 
    echo -e  "\n . . . nginx not found"
fi






