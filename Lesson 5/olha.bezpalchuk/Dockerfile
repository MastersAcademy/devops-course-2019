FROM ubuntu:18.04
RUN apt-get update && apt-get -y install nginx
COPY index.html /var/www/html/index.html
RUN service nginx restart
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
