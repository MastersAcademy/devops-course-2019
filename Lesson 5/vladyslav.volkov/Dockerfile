FROM ubuntu
RUN apt-get update && apt-get install nginx -y
COPY index.html /var/www/html/
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]