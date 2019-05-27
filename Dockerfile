FROM ubuntu:16.04
MAINTAINER AlexCobra <AlexCobraMk3@gmail.com>

ENV DATE_TIMEZONE UTC
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y upgrade

RUN apt-get install -y software-properties-common

RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get install -y zip unzip && apt-get update
RUN apt-get install -y php7.2

RUN apt-get install apache2 libapache2-mod-php7.2 -y
RUN apt-get install mysql-server mysql-client -y

RUN /bin/ln -sf /dev/stderr /var/log/apache2/error.log && \
    /bin/sed -i 's/AllowOverride\ None/AllowOverride\ All/g' /etc/apache2/apache2.conf && \
    /bin/ln -sf /dev/stdout /var/log/apache2/access.log && \
    /bin/sed -i "s/\;date\.timezone\ \=/date\.timezone\ \=\ ${DATE_TIMEZONE}/" /etc/php/7.2/apache2/php.ini

RUN a2enmod rewrite
RUN chown -R www-data:www-data /var/www/html

RUN systemctl enable mysql && service mysql start

VOLUME /var/www/html
VOLUME /var/log/httpd
VOLUME /var/lib/mysql
VOLUME /var/log/mysql
VOLUME /etc/apache2

EXPOSE 80


