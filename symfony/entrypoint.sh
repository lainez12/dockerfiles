#!/bin/sh

# Configura Git con las variables de entorno
git config --global user.name "${GIT_USER_NAME}"
git config --global user.email "${GIT_USER_EMAIL}"

cd "/var/www/html"

# Verifica si el directorio de la aplicación existe, si no, crea una nueva aplicación Symfony
if [ ! -d "/var/www/html/${NAME_APP}" ]; then
    symfony new "${NAME_APP}"
    # Instala las dependencias necesarias
	cd ${NAME_APP}
	composer require api
	composer require symfony/maker-bundle --dev
	composer require --dev orm-fixtures --dev
	composer require doctrine/fixtures:load
	composer require "lexik/jwt-authentication-bundle"
	echo "composer requires end"
fi

# Navega al directorio de la aplicación
cd "/var/www/html/${NAME_APP}"

# Reemplaza la línea DATABASE_URL en el archivo .env
if [ -f ".env" ]; then
    # Escapa caracteres especiales en PASS_BD para evitar problemas con sed
    ESCAPED_PASS_BD=$(printf '%s\n' "$PASS_BD" | sed -e 's/[\/&]/\\&/g')
    # Reemplaza la línea DATABASE_URL
    sed -i "s/^DATABASE_URL=.*/DATABASE_URL=\"${SGBD}:\/\/${USER_BD}:${ESCAPED_PASS_BD}@${NAME_BD}:${PORT_BD}\/${NAME_APP}\"/" .env
fi

if [ ! -d "config/jwt" ]; then
	# Genera el par de claves JWT
	php bin/console lexik:jwt:generate-keypair
fi
# Ejecuta el comando principal del contenedor (por ejemplo, iniciar Apache)
symfony serve --allow-http --no-tls --allow-all-ip

$@

