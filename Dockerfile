FROM php:8.0-apache
WORKDIR /var/www/html

RUN sed -i 's#http://deb.debian.org#https://mirrors.aliyun.com#g' /etc/apt/sources.list

RUN apt-get update && apt-get install -y git unzip zip zlib1g-dev libzip-dev \
    libwebp-dev libpng-dev libjpeg-dev libfreetype6-dev

# install php extensions
RUN docker-php-ext-install pdo_mysql gd bcmath opcache zip
RUN docker-php-ext-enable opcache
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp
# @TODO enable redis

# update php settings
COPY ./docker-init/php.custom.ini /usr/local/etc/php/conf.d/php.custom.ini
#COPY ./docker-init/index.php public/index.php

COPY ./docker-init/000-default.conf /etc/apache2/sites-enabled/000-default.conf

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    a2enmod rewrite && \
    service apache2 restart

# install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# change to aliyun mirror
RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

# RUN composer install
# create a larave project
# CMD composer create-project laravel/laravel ./

EXPOSE 80
EXPOSE 443