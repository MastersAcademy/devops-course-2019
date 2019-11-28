FROM ubuntu:19.04

RUN apt update && apt install nginx -y

COPY index.html /var/www/html

RUN service nginx restart

EXPOSE 80

CMD  ["nginx", "-g", "daemon off;"]
