FROM php:8-apache
RUN apt-get update && apt-get install -y \
        unzip \
        libzip-dev \
        git \
    && docker-php-ext-install zip
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs
RUN docker-php-ext-install mysqli pdo pdo_mysql
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
ENV APACHE_DOCUMENT_ROOT=/var/www/html/
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
RUN chown -R www-data:www-data /var/www/html && a2enmod rewrite
EXPOSE 8099