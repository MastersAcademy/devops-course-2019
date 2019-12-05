#!/bin/bash
sudo apt-get purge -y docker* docker-engine docker.io containerd runc
sudo rm -rf /var/lib/docker
echo "The docker remove"
