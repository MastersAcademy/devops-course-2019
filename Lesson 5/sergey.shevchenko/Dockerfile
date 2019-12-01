FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install -y curl nginx
COPY index.html /var/www/html/index.html
RUN service nginx restart
EXPOSE 80
CMD  ["nginx","-g","daemon off;"]
