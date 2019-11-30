if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

name='test_image'
docker build -t ${name} .
id=$(docker run -p 8181:80 -d $name)
echo $(curl 127.0.0.1:8181)
docker rm $(docker container stop ${id}) > /dev/null
