# Use the official PHP image with Apache
FROM php:8.3-alpine

# Define variables de entorno por defecto
ENV GIT_USER_NAME="Default User"
ENV GIT_USER_EMAIL="default.user@example.com"
ENV NAME_APP="none"
ENV NAME_BD="bd"
ENV PORT_BD="8000"
ENV USER_BD="user"
ENV PASS_BD="!ChangeMe!"
ENV SGBD="postgresql"


# Install necessary PHP extensions and utilities
RUN apk update 
RUN apk add --no-cache \
        git \
        libpq-dev \
        libaio \
        gnupg \
        unzip \
        nano \
        acl \
        wget \
        curl \
        postgresql-dev \
        autoconf \
		gcc \
		php83-dev \
        musl-dev \
        make \
        linux-headers \
        bash \
        lsb-release

#RUN apk add --no-cache \
#        php-pecl \
#        php-dev

RUN docker-php-ext-install pdo pdo_pgsql pdo_mysql

# Configura Git con las variables de entorno
#RUN git config --global user.name "${GIT_USER_NAME}" && \
#    git config --global user.email "${GIT_USER_EMAIL}"

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    wget -q -O - https://composer.github.io/installer.sig > expected_signature.txt && \
    EXPECTED_SIGNATURE=$(cat expected_signature.txt) && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === trim(file_get_contents('expected_signature.txt'))) { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); exit(1); } echo PHP_EOL;" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    php -r "unlink('composer-setup.php');" && \
    rm expected_signature.txt

# Install Xdebug for PHP debugging
RUN pecl install xdebug && \
    docker-php-ext-enable xdebug

# Crea el archivo de configuración de Xdebug
RUN echo "zend_extension=xdebug.so" > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.mode=debug,coverage" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.log=/tmp/xdebug.log" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.log_level=10" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Install Symfony
RUN curl -sS https://get.symfony.com/cli/installer | bash

RUN mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

#RUN symfony new "${NAME_APP}"

# Configura el entorno de trabajo
WORKDIR /var/www/html

#RUN symfony composer require api

#RUN composer require symfony/maker-bundle --dev

#RUN composer require --dev orm-fixtures

#RUN composer require "lexik/jwt-authentication-bundle"

#RUN php bin/console lexik:jwt:generate-keypair

# Copia el script de entrada al contenedor
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Da permisos de ejecución al script de entrada
RUN chmod +x /usr/local/bin/entrypoint.sh

# Define el script de entrada
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Expose ports for Symfony 
EXPOSE 8000

#Shell by default
SHELL ["/bin/bash", "-c"]

# Start Server Symfony
# CMD ["symfony serve --allow-all-ip -d"]
