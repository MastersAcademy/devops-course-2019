FROM ubuntu:18.04 as nginx
RUN apt update &&\
    apt install -y curl gnupg2 ca-certificates lsb-release &&\
    echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" > /etc/apt/sources.list.d/nginx.list &&\
    curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add - &&\
    apt update &&\
    apt -y install nginx=1.14.2-1~bionic && \
    mkdir -p /etc/nginx/sites-available && \
    mkdir -p /etc/nginx/sites-enabled && \
    mv /etc/nginx/conf.d/default.conf /etc/nginx/sites-available && \
    ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled && \
    echo "include /etc/nginx/sites-enabled/*.conf;" > /etc/nginx/conf.d/include.conf && \
    nginx -t && service nginx restart    
COPY /html /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
