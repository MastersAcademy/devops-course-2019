#!/bin/bash
#set -x

 echo "enter your package name"
    read name


    dpkg -s $name  &> /dev/null
echo $? -ne 0;
	if [ $? -ne 0 ];
	 then
           echo "not installed"
           sudo apt-get update
           sudo apt-get install $name
         else
	   dpkg -l $name
           sudo apt remove $name
    fi
exit 1;
