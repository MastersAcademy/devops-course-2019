FROM ubuntu:18.04
MAINTAINER Alexey Berkut <alberkutoff@gmail.com>
RUN apt update && apt install -y nginx
COPY /html /var/www/html/
WORKDIR /var/www/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

