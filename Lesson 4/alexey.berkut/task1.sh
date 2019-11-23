#!/bin/bash
apt remove docker*;
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D; # Add GPG offical key
apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'; # Add Docker repo in APT
apt update || apt install -y docker-engine;
usermod -aG docker sailor;
service status docker;

