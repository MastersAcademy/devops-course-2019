#!/bin/bash

#1. Используя навыки приобретенные в предыдущем уроке, составьте скрипт выполняющий:
# 1.1 Удаление пакета docker или его модификаций

YLW='\033[1;33m'
NC='\033[0m'

APP_NAME=docker
DOCKER_USER=sailor
APP_CONT_NAME=ubuntu-16.04
DOCKER_IMAGE=ubuntu:16.04

echo -e "\n${YLW}Remove old vrersion...${NC}"
  sleep 1
apt-get remove docker docker-engine docker.io containerd runc -y || true

#rm -rf /var/lib/docker

# 1.2 Установку пакета docker-ce
echo -e "\n${YLW}Update the apt package index...${NC}"
  sleep 1
apt-get update

echo -e "\n${YLW}Install prerequisites...${NC}"
  sleep 1
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

echo -e "\n${YLW}Add Docker’s official GPG key...${NC}"
  sleep 1

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

echo -e "\n${YLW}Update the apt package index...${NC}"
  sleep 1

apt-get update

echo -e "\n${YLW}Install the latest version of Docker Engine - Community and containerd...${NC}"
  sleep 1

apt-get install -y docker-ce docker-ce-cli containerd.io

echo -e "\n${YLW}Create the docker group...${NC}${NC}"
  sleep 1
groupadd docker

####
echo -e "\n${YLW}Configure Docker to start on boot with systemd...${NC}"
  sleep 1

systemctl enable docker

# 1.3 добавление пользователя с именем sailor (или любого другого) с правом запуска контейнеров
echo -e "\n${YLW}Add user to the docker group...${NC}"
  sleep 1

useradd -m -c "Docker user" $DOCKER_USER -s /bin/bash

echo -e "\n${YLW}Create the docker group...${NC}"
  sleep 1

usermod -aG docker $DOCKER_USER

#echo -e "\n${YLW}Activate the changes to groups...${NC}"
#  sleep 1

#newgrp docker

# 2. Используя пользователя из пункта 1.iii запустить контейнер ubuntu:16.04 в интерактивном режиме
echo -e "\n${YLW}Run container...${NC}"
  sleep 1
runuser -l $DOCKER_USER -c " \
  docker stop ${APP_CONT_NAME} || true \
  && docker rm -v ${APP_CONT_NAME} || true \
  &&  docker rmi ${DOCKER_IMAGE} || true \
  &&  docker pull ${DOCKER_IMAGE} \
  &&  docker run -d -it \
      --name ${APP_CONT_NAME} \
      --restart always \
      -p 8081:80 \
      ${DOCKER_IMAGE}"

#3. Обеспечить работоспособность скрипта из урока 2 внутри данного контейнера

echo -e "\n${YLW}Copy script to a container...${NC}"
  sleep 1
docker cp lesson_2.sh ${APP_CONT_NAME}:/lesson_2.sh

echo -e "\n${YLW}Run script inside the container...${NC}"
  sleep 1
docker exec -it ${APP_CONT_NAME} bash /lesson_2.sh

