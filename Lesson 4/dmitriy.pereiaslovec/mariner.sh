#!/bin/bash

echo "------------------------"
echo "Check for current user rights";
echo "------------------------"

if [[ $(id -u) -ne 0 ]]
  then
    echo "------------------------"
    echo "Please run as root"
    echo "------------------------"
    exit 0;
  else
    echo "------------------------"
    echo "Start executing tasks"
    echo "------------------------"
fi
echo ""
if [[ $(which docker) && $(docker --version) ]]; then
   echo "------------------------"
   echo "Docker installed and will be deleted in"
   echo "------------------------"
   echo ""
   apt purge -y docker*
   apt-get update;
fi

    echo "Start installation docker community edition"
    apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt install docker-ce -y
    
    echo ""
    echo "Creating user \"mariner\" in system and adding him to the “docker” group"
    adduser mariner --disabled-password --gecos ""
    usermod -aG docker mariner
    echo ""
    echo "------------------------"
    echo 'Run container "test" in foreground'
    echo ""
    su - mariner -c 'docker run -dit --name test --rm ubuntu:16.04'
    echo ""
    echo "------------------------"
    echo "Execute some command from container:"
    echo "";
    su - mariner -c 'docker exec -it test cat /etc/os-release'
    echo ""
    echo "------------------------"
    echo "Check if container still running:"
    echo ""
    su - mariner -c 'docker ps -a'
    echo ""
    echo "------------------------"
    echo "Killing container:"
    echo ""
    su - mariner -c 'docker kill test'
    echo ""
    echo "------------------------"
    echo "Check that container removed:"
    echo ""
    su - mariner -c 'docker ps -a'
    echo ""
