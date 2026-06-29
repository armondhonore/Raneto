FROM mirror.gcr.io/library/php:8.2-apache

# Install dependencies for Raneto
RUN apt-get update && apt-get install -y \
    libsqlite3-dev \
    libpng-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo pdo_sqlite gd

# Enable Apache rewrite module
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy application source
COPY . .

# Raneto expects a config.php file. If it doesn't exist, it might crash or redirect.
# We create a basic config.php based on common Raneto requirements to prevent 503s.
# We also ensure the data directory exists and is writable.
RUN mkdir -p /var/www/html/data && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html/data

# Create a default config.php if one doesn't exist to ensure the app bootstraps
RUN if [ ! -f config.php ]; then \
    echo "<?php\n\$config = [\n    'db' => 'sqlite:/var/www/html/data/raneto.db',\n    'url' => 'http://localhost',\n];\n" > config.php; \
    chown www-data:www-data config.php; \
    fi

EXPOSE 80

# Start Apache in foreground
CMD ["apache2-foreground"]