#!/bin/bash

apt install sudo

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

sudo apt-get purge -y docker docker-engine docker.io containerd runc

dockerState=$(dpkg -l|grep -e "ii  docker ")

if [ -n $dockerState ]
then
	echo "Install Docker-CE"
else
	echo "Docker almost there"
fi

sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose
docker-compose up -d --build

function checkRun {
imageFlag=`docker image ls |grep -e "v.kharlamov_image"`
runContainerFlag=`docker ps|grep -e "v.kharlamov_image"`
containerPresent=`docker ps -a|grep -e "v.kharlamov_image"`
}

checkRun

if [ -n "$imageFlag" ]
then
	if [ -n "$runContainerFlag" ]
	then
		curl_output=`curl 127.0.0.1:8181 2> /dev/null`
		echo -e "\nCurl output: $curl_output"
		echo -e "\n"
		sleep 1
		echo -e "Remove? [Y/n] \n"
		read -s -n 1 remove

        	if [[ $remove = "n" ]]
        	then
			exit 0
		fi
	else
		echo "Container not runed"
		exit 1
	fi
else
	echo "No docker image"
	exit 1
fi

docker stop v.kharlamov_image
docker rm v.kharlamov_image
docker image rm v.kharlamov_image

checkRun


if [ -n "$imageFlag" ]
then
	echo "Docker image not removed"
	exit 1
fi

if [ -n "$runContainerFlag" ]
then
	echo "Container almost run"
	exit 1
fi

if [ -n "$containerPresent" ]
then
	echo "Container almost present"
	exit 1
fi

exit 0
