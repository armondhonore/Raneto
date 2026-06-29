FROM mirror.gcr.io/library/php:8.2-apache

# Install dependencies for Raneto (PHP extensions and system tools)
RUN apt-get update && apt-get install -y \
    libsqlite3-dev \
    libpng-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo pdo_sqlite gd

# Enable Apache rewrite module
RUN a2enmod rewrite

# Set working directory to the Apache document root
WORKDIR /var/www/html

# Copy application source
COPY . .

# Set permissions for the web server
RUN chown -R www-data:www-data /var/www/html

# Raneto is a PHP app; it doesn't use npm for the core engine
# The previous Dockerfile was incorrectly using a Node image

EXPOSE 80

# Apache runs in the foreground by default in this image