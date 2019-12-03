#!/bin/bash

if [ "$EUID" -ne 0 ]
then
  echo 'Please run as root'
  exit
fi

# = 1.1 Delete docker or it's modifications =
# remove older versions of Docker
apt-get remove docker docker-engine docker.io containerd runc

# = 1.2 Install docker-ce =
# update apt package
apt-get update

# Install packages to allow apt to use a repository over HTTPS
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# install stable release
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install the latest version of Docker Engine
apt-get install -y docker-ce docker-ce-cli containerd.io

# = 1.3 Add user sailor (or any other) with permission to run containers =
# create user "sailor"
adduser sailor --disabled-password --gecos ""

# add user "sailor" to the "docker" group
usermod -aG docker sailor

# = 2. Using user from 1.3 run container ubuntu:16.10 interactively =

# change to sailor
# build and run container
su - sailor bash -c 'docker run -it ubuntu:16.04 bash'
