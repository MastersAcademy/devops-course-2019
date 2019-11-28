FROM alpine

RUN apk update && \
    apk add nginx && \
    apk add php-fpm && \
    apk add php-mysqli && \
    mkdir /run/nginx;

COPY default.conf /etc/nginx/conf.d/

WORKDIR /var/www/localhost/htdocs

COPY wp-app/ .

EXPOSE 80

CMD ["/bin/sh", "-c", "/usr/sbin/php-fpm7; exec nginx -g 'daemon off;';"]