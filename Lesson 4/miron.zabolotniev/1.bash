sudo apt-get remove docker docker-engine docker.io containerd runc --yes
sudo apt-get update
sudo apt install docker.io --yes
sudo useradd sailor
sudo usermod -aG docker sailor
su sailor -c 'docker run -t -i ubuntu:16.04 /bin/bash '