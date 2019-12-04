FROM ubuntu:18.04
LABEL maintainer="vlad@kharlamov.com.ua"
RUN apt update
RUN apt install -y nginx
COPY index.html /var/www/html/
EXPOSE 80/tcp
CMD  ["nginx","-g","daemon off;"]
