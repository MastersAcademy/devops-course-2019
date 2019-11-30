FROM ubuntu:14.04
RUN apt update
RUN apt install -y nginx
COPY index.html /var/www/html/
RUN service nginx restart
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]