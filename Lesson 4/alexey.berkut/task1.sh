#!/bin/bash

if [[ "$EUID" -ne 0  ]]
then
	echo "Please run as root";
	exit 0;
fi

apt remove docker*;
apt update;

apt install -y apt-transport-https ca-certificates curl software-properties-common;
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -;
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" # Add repo
apt install -y docker-ce;

adduser sailor --disabled-password --gecos "";
usermod -aG docker sailor;
systemctl restart docker.service;

# Test
docker run hello-world;

su - sailor bash -c "docker run --rm ubuntu:16.04";

