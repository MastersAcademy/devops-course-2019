#!/bin/bash
apt-get purge -y docker-ce
apt-get autoremove -y docker docker-engine docker.io containerd runc
rm -rf /var/lib/docker
apt update
apt install -y  apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt update
apt-cache policy docker-ce
apt install -y docker-ce
adduser sailor --disabled-password
usermod -aG docker sailor
sudo -u sailor docker run --rm -it ubuntu:16.04
