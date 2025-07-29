# Use official PHP 8.3 image with Apache support
FROM php:8.3-apache

# Install system dependencies and required PHP extensions
RUN apt-get update && apt-get install -y --no-install-recommends \
    git unzip curl libzip-dev libjpeg-dev libpng-dev \
    libfreetype6-dev libicu-dev libxml2-dev libpq-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install mysqli gd intl zip soap exif pgsql pdo_pgsql opcache && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Clone a specific Moodle stable version
RUN git clone --depth=1 --branch=MOODLE_404_STABLE git://git.moodle.org/moodle.git /var/www/html

# Set up custom PHP configurations
RUN echo "max_input_vars=5000" > /usr/local/etc/php/conf.d/moodle.ini && \
    echo "opcache.enable=1" > /usr/local/etc/php/conf.d/opcache.ini && \
    echo "opcache.memory_consumption=128" >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo "opcache.max_accelerated_files=10000" >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo "opcache.validate_timestamps=1" >> /usr/local/etc/php/conf.d/opcache.ini

# Create Moodle data directory and set permissions
RUN mkdir -p /var/www/moodledata && \
    chown -R www-data:www-data /var/www && \
    chmod -R 755 /var/www

WORKDIR /var/www/html
EXPOSE 80

