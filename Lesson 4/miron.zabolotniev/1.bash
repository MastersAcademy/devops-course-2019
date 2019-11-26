if [ "$id" -ne 0 ]
	then echo "Run script by sudo"
	exit 0;
fi
apt-get remove docker docker-engine docker.io containerd runc --yes
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
useradd sailor
usermod -aG docker sailor
su sailor -c 'docker run -t -i ubuntu:16.04 /bin/bash '