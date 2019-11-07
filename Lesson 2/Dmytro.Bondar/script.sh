#!/bin/bash
dpkg --list > ~/list
if grep nginx ~/list
then
nginx -V
else
 echo "no nginx installed"
fi

