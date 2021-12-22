FROM ubuntu:21.04
MAINTAINER  jens@justiversen.dk

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get clean && apt-get -y update && apt-get install -y locales curl software-properties-common git \
  && locale-gen en_US.UTF-8 
RUN LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php
RUN apt-get update
RUN apt-get install -y php8.0-bcmath php8.0-bz2 php8.0-cli php8.0-common php8.0-curl \
                php8.0-cgi php8.0-dev php8.0-fpm php8.0-gd php8.0-gmp php8.0-imap php8.0-intl \
                php8.0-ldap php8.0-mbstring php8.0-mysql \
                php8.0-odbc php8.0-opcache php8.0-pgsql php8.0-phpdbg php8.0-pspell \
                php8.0-readline php8.0-soap php8.0-sqlite3 \
                php8.0-tidy php8.0-xml php8.0-xmlrpc php8.0-xsl php8.0-zip \
                php-tideways php-mongodb

RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/8.0/cli/php.ini
RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/8.0/fpm/php.ini
RUN sed -i "s/display_errors = Off/display_errors = On/" /etc/php/8.0/fpm/php.ini
RUN sed -i "s/upload_max_filesize = .*/upload_max_filesize = 10M/" /etc/php/8.0/fpm/php.ini
RUN sed -i "s/post_max_size = .*/post_max_size = 12M/" /etc/php/8.0/fpm/php.ini
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/8.0/fpm/php.ini

RUN sed -i -e "s/pid =.*/pid = \/var\/run\/php8.0-fpm.pid/" /etc/php/8.0/fpm/php-fpm.conf
RUN sed -i -e "s/error_log =.*/error_log = \/proc\/self\/fd\/2/" /etc/php/8.0/fpm/php-fpm.conf
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/8.0/fpm/php-fpm.conf
RUN sed -i "s/listen = .*/listen = 9000/" /etc/php/8.0/fpm/pool.d/www.conf
RUN sed -i "s/;catch_workers_output = .*/catch_workers_output = yes/" /etc/php/8.0/fpm/pool.d/www.conf

RUN curl https://getcomposer.org/installer > composer-setup.php && php composer-setup.php && mv composer.phar /usr/local/bin/composer && rm composer-setup.php

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 9000
CMD ["php-fpm8.0"]

