FROM ubuntu:18.04
MAINTAINER Serhii Mitsenko

RUN apt update
RUN apt install -y nginx
COPY index.html /var/www/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
