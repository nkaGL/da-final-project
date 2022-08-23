FROM debian:buster

RUN apt-get update
RUN apt-get install -y apt-transport-https ca-certificates curl apt gnupg --no-install-recommends

RUN curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key  |  apt-key add -

RUN echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list

RUN groupadd -g 1001 jenkins && adduser jenkins --disabled-password --home "/var/lib/jenkins" --uid 1001 --gid 1001 --shell "/bin/bash"

RUN apt-get update

RUN apt-get install -y jenkins --no-install-recommends
RUN apt-get install -y git default-jdk

RUN sed -i -e 's/PREFIX\=\/\$NAME/PREFIX\=\/ci2/g' /etc/default/jenkins
RUN sed -i -e 's/HTTP\_PORT\=8080/HTTP_PORT=-1/g' /etc/default/jenkins
RUN echo 'JENKINS_ARGS="--prefix=$PREFIX -Duser.timezone=Europe/Warsaw --httpsPort=8443 --httpsKeyStore=/var/lib/jenkins/jenkins_store_ssl.jks --httpsKeyStorePassword=<pass_do_klucza_ssl>"' >> /etc/default/jenkins

RUN echo 'Europe/Warsaw' > /etc/timezone

ENTRYPOINT  service jenkins start && /bin/bash

