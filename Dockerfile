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

# Fix permissions and initialize config in a single RUN block to ensure reliability
RUN chown -R www-data:www-data /var/www/html && \
    if [ ! -f config.php ]; then \
        cp config.sample.php config.php || touch config.php; \
    fi && \
    chmod 666 config.php || true

EXPOSE 80

CMD ["apache2-foreground"]