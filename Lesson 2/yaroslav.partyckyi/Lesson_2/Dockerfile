FROM ubuntu:19.04

RUN apt update
RUN apt -y upgrade
RUN apt install -y nginx    

COPY script.sh script.sh

RUN chmod +x script.sh

CMD ["bash", "script.sh"]