#!/bin/bash

#variables
program="htop"
if [ -n "$1" ]
then
  program=$1
fi

echo "Start script"

apt list >> tempfile

if grep $program tempfile; then 
  echo "I'm find \"$program\""
   #$program -v ;



  rm tempfile
  exit 1;
fi



# delete tempfile
rm tempfile; 

echo "All done";
exit 1;
