FROM mirror.gcr.io/library/php:8.2-apache

# Install system dependencies for Raneto
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libmariadb-dev-compat \
    libmariadb-dev \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo_mysql

# Enable Apache rewrite module
RUN a2enmod rewrite

# Set working directory to Apache's document root
WORKDIR /var/www/html

# Copy application source
COPY . .

# Raneto requires a config.php file to start. 
# If it's missing, it might trigger a crash or a redirect that causes 503s if not handled.
# We ensure the directory is writable for the installer/app.
RUN chown -R www-data:www-data /var/www/html

# Create a dummy config.php if it doesn't exist to prevent startup crashes
# and ensure the app is in a state where it can be accessed.
RUN if [ ! -f config.php ]; then cp config.sample.php config.php || touch config.php; fi
RUN chown www-data:www-data config.php

EXPOSE 80

CMD ["apache2-foreground"]