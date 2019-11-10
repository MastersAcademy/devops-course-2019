#!/bin/bash

# 1. Show list of installed programs and check if nginx is in there
echo '\t===== task 1 ====='
echo '> list of installed programs:'
dpkg -l
echo '> checking for nginx...'
if dpkg -l | grep nginx > /dev/null 2>&1;
then
  # 1.1 If yes, uninstall nginx and show message about deleting. Specify uninstalled version.
  echo '> nginx found'
  VERSION=$(nginx -v)
  echo "> uninstalling nginx version ${VERSION}..."
  apt-get purge nginx nginx-common
  apt-get autoremove
  echo "> nginx uninstalling - complete"
else
  # 1.2 If no, show message about not being installed
  echo '> nginx not found'
fi
