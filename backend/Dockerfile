FROM php:8.4-cli

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev \
    libonig-dev libxml2-dev libzip-dev \
    libssl-dev libcurl4-openssl-dev

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql gd mbstring xml zip opcache

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working dir
WORKDIR /var/www/html

# Copy composer files first for better layer caching
COPY backend/composer.json backend/composer.lock* ./

# Install dependencies (without scripts first to avoid issues)
RUN composer install --no-scripts --no-autoloader --no-interaction --prefer-dist -vvv || \
    (echo "First install attempt failed, retrying..." && \
     composer install --no-scripts --no-autoloader --no-interaction --prefer-dist --ignore-platform-reqs -vvv)

# Copy all source files
COPY backend/ .

# Run composer install again to execute scripts and generate autoloader
RUN composer install --no-interaction --prefer-dist || \
    composer install --no-interaction --prefer-dist --ignore-platform-reqs

# Expose port for artisan serve
EXPOSE 8000

CMD php artisan serve --host=0.0.0.0 --port=8000
