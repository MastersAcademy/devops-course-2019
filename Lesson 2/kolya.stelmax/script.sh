#!/bin/bash
if

 dpkg --list | grep nginx;

then
nginx -v;
else
echo "nxing is not installed";
apt remove nginx;

fi
exit 0;
