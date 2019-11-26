#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

sudo apt-get purge -y docker docker-engine docker.io containerd runc

dockerState=$(dpkg -l|grep -e "docker ")

if [ -z $dockerState ]
then
	echo "Docker not installed"
	sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common pwgen
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	sudo apt-get update
	sudo apt-get install -y docker-ce docker-ce-cli containerd.io
	pass=$(pwgen -ncs 12 1)
	mkdir /home/sailor
	useradd sailor -p $pass -g docker -s /bin/bash -d /home/sailor/
	chown -R sailor /home/sailor
	echo -e "\e[32mUser sailor password: $pass\e[0m"
	#su - sailor -c 'docker run -it ubuntu:16.04 ./script.sh'
	cp script.sh /home/sailor/script.sh
	su - sailor -c "docker run -td --name forscript ubuntu:16.04 && docker cp script.sh forscript:/script.sh && docker exec -it forscript ./script.sh"
else
	echo "Docker almost here"
	exit
fi
