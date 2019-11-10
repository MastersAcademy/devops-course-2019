#!/bin/bash

set -x

 echo "enter your package name";
    read name;

    dpkg -s $name  1>/dev/null;
        if [ $? -ne 0 ]; then
            echo $name "not installed" && sudo apt-get update && sudo apt-get install $name
          else
            dpkg -l $name && sudo apt remove -y $name;
        fi
exit 1;

