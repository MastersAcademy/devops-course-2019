FROM ubuntu:19.04 as default
WORKDIR /
RUN apt update
RUN apt -y upgrade
COPY script.sh script.sh
RUN chmod +x script.sh
CMD ["bash", "./script.sh"]

FROM default as nginx
RUN apt install -y nginx
