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
COPY ./docker-init/index.php public/index.php
#COPY src/ src

COPY ./docker-init/000-default.conf /etc/apache2/sites-enabled/000-default.conf

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    a2enmod rewrite && \
    service apache2 restart

# install Composer
#RUN cd /tmp && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
COPY --from=composer:2.0 /usr/bin/composer /usr/local/bin/composer

#RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini
#RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5#/apache2/php.ini
#RUN sed -i "s/upload_max_filesize = .*$/upload_max_filesize = 100M/" /usr/local/etc/php/php.ini

# RUN composer install

EXPOSE 80
