FROM mirror.gcr.io/library/php:8.2-apache

# Install dependencies with a more robust set of packages for PHP stability
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libmariadb-dev-compat \
    libmariadb-dev \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install essential PHP extensions for Raneto
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo_mysql

# Enable rewrite for Raneto's URL structure
RUN a2enmod rewrite

# Set Apache document root to /var/www/html
WORKDIR /var/www/html

# Copy source files
COPY . .

# Fix ownership and ensure config exists
# We use a more aggressive approach to ensure config.php is writable and present
RUN chown -R www-data:www-data /var/www/html && \
    (if [ -f config.sample.php ]; then cp config.sample.php config.php; else touch config.php; fi) && \
    chmod 666 config.php

# Set environment variable to ensure Apache logs to stdout/stderr
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80

CMD ["apache2-foreground"]