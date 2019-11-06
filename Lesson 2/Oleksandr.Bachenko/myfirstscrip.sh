#!/bin/bash
if 
  dpkg —list | grep nginx
then
  nginx -V
else
  echo "no nginx installed"
fi
