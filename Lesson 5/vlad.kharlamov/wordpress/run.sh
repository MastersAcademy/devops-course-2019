#!/bin/bash

apt install sudo

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

docker_process=`docker ps -a|awk '/v.kharlamov/{count++}END{print count}'`
if [[ $docker_process = 2 ]]
then
echo "Images present. Remove? [y/N]"
read -s -n 1 dockerRm

        if [[ $dockerRm = "y" ]]
	then
	docker stop v.kharlamov_image
	docker stop v.kharlamov_mysql
	docker rm v.kharlamov_image
	docker image rm v.kharlamov_image
	docker rm v.kharlamov_mysql
	docker image rm v.kharlamov_mysql
	echo "Removed"
	echo "Database in ./mysql"
	exit 0
	else
		echo "Exit"
		exit 0
	fi
fi
sudo apt-get purge -y docker docker-engine docker.io containerd runc

dockerState=$(dpkg -l|grep -e "ii  docker ")

if [ -n $dockerState ]
then
        echo "Install Docker-CE"
else
        echo "Docker almost there"
fi

sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common pwgen
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose

pass=$(pwgen -c -n 16 1)
rootpass=$(pwgen -c -n 16 1)

for ((i = 1; i < 9; i++))
do
eval "salt$i=\"$(pwgen 64 1)\"";
done

echo "
<?php
define( 'DB_NAME', 'wordpress' );

define( 'DB_USER', 'wordpress' );

define( 'DB_PASSWORD', '$pass' );

define( 'DB_HOST', 'mysql' );

define( 'DB_CHARSET', 'utf8' );

define( 'DB_COLLATE', '' );

define( 'AUTH_KEY',         '$salt1' );
define( 'SECURE_AUTH_KEY',  '$salt2' );
define( 'LOGGED_IN_KEY',    '$salt3' );
define( 'NONCE_KEY',        '$salt4' );
define( 'AUTH_SALT',        '$salt5' );
define( 'SECURE_AUTH_SALT', '$salt6' );
define( 'LOGGED_IN_SALT',   '$salt7' );
define( 'NONCE_SALT',       '$salt8' );

\$table_prefix = 'wp_';

define( 'WP_DEBUG', false );

if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}

require_once( ABSPATH . 'wp-settings.php' );

" > wp-config.php


echo "
version: '3'
services:
 nginx:
   build: .
   ports:
      - 8181:80
   container_name: v.kharlamov_image
   image: v.kharlamov_image
   environment:
             - DB_HOST=mysql
   links:
      - mysql
 mysql:
     volumes:
       - ./mysql:/var/lib/mysql
     restart: always
     environment:
       MYSQL_ROOT_PASSWORD: $rootpass
       MYSQL_DATABASE: wordpress
       MYSQL_USER: wordpress
       MYSQL_PASSWORD: $pass
     ports:
        - 3306:3306
     container_name: v.kharlamov_mysql
     image: mysql:5.7

" > docker-compose.yml

docker-compose up -d --build

docker_process=`docker ps|awk '/v.kharlamov/{count++}END{print count}'`
if [ $docker_process = 2 ]
then
echo "Complete"
echo -e "My containers: \n$(docker ps|awk '/v.kharlamov/{print $0}')"
echo "-----------"
echo "MySQL User: wordpress Password: $pass"
echo "MySQL root user pass: $rootpass"
echo "-----------"
echo "For remove containers, please run this script again"
else
echo "Something wrong"
echo -e "My containers: \n$(docker ps|awk '/v.kharlamov/{print $0}')"
fi
