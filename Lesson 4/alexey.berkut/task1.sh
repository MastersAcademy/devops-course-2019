#!/bin/bash

if [[ "$EUID" -ne 0  ]]
then
	echo "Please run as root";
	exit 0;
fi

apt remove docker*;

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D; # Add offical GPG key
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" # Add Docker repo in APT

apt update;
apt install -y docker-ce docker-ce-cli containerd.io;

adduser sailor --disabled-password --gecos "";
usermod -aG docker sailor;
systemctl start docker.service;

su - sailor bash -c "docker run --rm ubuntu:16.04";

