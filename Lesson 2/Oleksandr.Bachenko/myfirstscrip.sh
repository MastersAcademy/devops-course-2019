#!/bin/bash
if 
  dpkg —list | grep nano
then
  nano -V
else
  echo "no nginx installed"
fi
