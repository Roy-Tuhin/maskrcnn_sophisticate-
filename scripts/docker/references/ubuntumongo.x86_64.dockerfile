FROM ubuntu:18.04

MAINTAINER mangalbhaskar

## https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/
## https://github.com/hamptonpaulk/php7-dockerized/issues/3
## https://docs.docker.com/develop/develop-images/dockerfile_best-practices/

RUN apt-get update
RUN apt-get install -y gnupg wget

RUN wget -qO- https://www.mongodb.org/static/pgp/server-4.0.asc | apt-key add

RUN echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.0.list

RUN apt-get update
RUN apt-get install -y mongodb-org

RUN mkdir -p /data/db

EXPOSE 27017

CMD ["--port 27017"]

ENTRYPOINT usr/bin/mongod
