FROM ubuntu:16.04
WORKDIR / 
COPY nginx.sh nginx.sh
RUN chown root:root /nginx.sh
RUN chmod 4755 /nginx.sh
RUN apt-get update
RUN apt-get -y upgrade
ENTRYPOINT ["bash", "/nginx.sh"]
