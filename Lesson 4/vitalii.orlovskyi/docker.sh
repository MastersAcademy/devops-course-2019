#!/bin/bash
apt purge -y docker docker-ce docker-engine docker.io containerd runc
apt update
apt install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"
apt update

apt install -y docker-ce
adduser --disabled-password --gecos "" sailor
usermod -aG docker sailor

su - sailor -c 'docker pull ubuntu:16.04 && docker run -it --rm ubuntu:16.04'
