if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

apt-get install software-properties-common
apt-get install lsb-core --yes
apt-get install curl

apt-get remove docker docker-engine docker.io containerd runc --yes
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
useradd sailor
usermod -aG docker sailor
su sailor -c 'docker run -t -i ubuntu:16.04 /bin/bash '