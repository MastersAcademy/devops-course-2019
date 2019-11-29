FROM alpine:3.10

RUN apk update && apk add nginx && apk add openrc --no-cache \
	&& apk add bash && apk add curl \
	&& mkdir -p /run/nginx
COPY index.html /www/index.html
COPY default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80

CMD  ["nginx", "-g", "daemon off;"]
