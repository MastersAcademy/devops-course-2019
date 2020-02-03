FROM ubuntu:18.04
LABEL maintainer="vlad@kharlamov.com.ua"
RUN apt update
RUN apt install -y nginx php7.2-fpm php-mysql wget supervisor
RUN wget -P /home https://uk.wordpress.org/latest-uk.tar.gz
RUN cd /home && tar -xzf latest-uk.tar.gz && rm latest-uk.tar.gz
RUN mkdir /run/php
COPY default /etc/nginx/sites-available/
EXPOSE 80/tcp

ADD wp-config.php /var/www/wordpress/
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN cd /home && cp -r wordpress/ /var/www/
CMD ["/usr/bin/supervisord"]

