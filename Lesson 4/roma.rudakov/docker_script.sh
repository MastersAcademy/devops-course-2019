#!/bin/bash
if [[ $(id -u) -ne 0 ]]
  then
    echo "Please run as root";
    exit 0;
fi

	apt-get -y  remove docker docker-engine docker.io containerd runc
	apt-get -y update
	apt-get -y install \
    	apt-transport-https \
    	ca-certificates \
	curl \
	gnupg-agent \
	software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - 
	add-apt-repository \
	 "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   	$(lsb_release -cs) \
   	stable"
	apt-get update -y
	apt-get install -y docker-ce docker-ce-cli containerd.io
	adduser --disabled-password --gecos "" sailor
	usermod -aG docker sailor
	su - sailor -c 'docker run -it --rm --name test ubuntu:16.04 '
	
