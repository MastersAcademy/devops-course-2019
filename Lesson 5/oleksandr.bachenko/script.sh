sudo docker build -t oleksandr.bachenko .
sudo docker run -d -p 8181:80 oleksandr.bachenko
curl 127.0.0.1:8181

