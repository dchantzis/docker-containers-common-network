FROM ubuntu:18.04

LABEL maintainer="Dimitrios Chantzis"

WORKDIR /var/www

RUN apt-get update \
    && apt-get install -y gnupg tzdata \
    && echo "UTC" > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get dist-upgrade -y \
    && apt-get install -y build-essential \
    && apt-get install -y software-properties-common \
    && apt-get update \
    && apt-get install -y curl zip unzip git vim supervisor sqlite3 iputils-ping \
    && apt-get install -y nginx \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get install -y \
       php7.4-fpm \
       php7.4-cli \
       php7.4-pgsql \
       php7.4-sqlite3 \
       php7.4-gd \
       php7.4-memcached \
       php7.4-imap \
       php7.4-mysql \
       php7.4-mbstring \
       php7.4-xml \
       php7.4-zip \
       php7.4-bcmath \
       php7.4-soap \
       php7.4-intl \
       php7.4-readline \
       php7.4-cgi \
       php7.4-bz2 \
       php7.4-json \
       php7.4-xmlrpc \
       php7.4-odbc \
       php7.4-pspell \
       php7.4-tidy \
       php7.4-pgsql \
       php7.4-xdebug \
    && apt-get install -y php-pear \
    && apt-get install -y curl \
    && apt-get install -y php7.4-curl \
    && apt-get install -y imagemagick \
    && apt-get install -y php7.4-imagick \
    && apt-get install -y php-msgpack \
    && apt-get install php-igbinary \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && mkdir /run/php

## Caching
# Redis
RUN apt-get update \
    && apt-get -y install redis-server \
    && apt-get -y install php7.4-redis
# Memcached
#RUN apt-get update \
#    && apt-get -y install memcached \
#    && apt-get -y install php7.4-memcached

# To keep the installation clean, autoremove anything that can get removed
# Clean-up extra files
# Remove files from the temporary directories
RUN apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && echo "daemon off;" >> /etc/nginx/nginx.conf \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

COPY php/mods-available/xdebug.ini /etc/php/7.4/mods-available/xdebug.ini
COPY docker-configuration/php-mods/local.ini /usr/local/etc/php/conf.d/local.ini
ADD nginx/conf.d/default.conf /etc/nginx/sites-available/default
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD php/fpm/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf

# Copy ALL start-container* variants to the /usr/bin directory inside the container
COPY entrypoint/* /usr/bin/
RUN chmod +x /usr/bin/start-container
# Copy ALL application .env.* variants to the /usr/bin/app directory inside the container
COPY app/* /usr/bin/app-env-settings/

ENTRYPOINT ["start-container"]