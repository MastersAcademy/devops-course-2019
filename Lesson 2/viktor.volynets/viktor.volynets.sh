#! /bin/bash

if [[ $(id -u) -ne 0 ]]; then
  echo "Please run script as root"
  exit 1	
fi

echo "List of programs"
var=0;
apt list --installed | grep -c nginx && var=$(( $var+1 ));
if [ $var -eq 1 ]
then 
	
echo "Nginx install"
echo "Deinstal is start..."
echo $(nginx -v)
apt-get -y remove nginx nginx-common 
echo "Nginx Deinstal :)"
elif [ $var -eq 0 ]
then
echo "Nginx not installed"
fi





