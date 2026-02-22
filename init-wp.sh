#!/bin/bash
set -e

# 1. Wywołaj oryginalny entrypoint z argumentem, żeby zainicjował pliki
# Przekazujemy "apache2-foreground", aby wiedział co ma uruchomić po przygotowaniu
/usr/local/bin/docker-entrypoint.sh apache2-foreground &

# 2. Czekaj chwilę, aż skrypt zdąży skopiować pliki
echo "Czekam na inicjalizację plików..."
sleep 5

# 3. Teraz działaj na plikach (czekaj na bazę i instaluj)
while ! mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
    echo "Czekam na bazę..."
    sleep 2
done

if ! wp core is-installed --allow-root; then
    wp core install --allow-root \
      --url="http://localhost:8080" \
      --title="DevOps Portal" \
      --admin_user="admin" \
      --admin_password="AdminPass123!" \
      --admin_email="admin@test.local"
    wp plugin activate wp-file-manager --allow-root
    
fi

echo -e "User-agent: *\nDisallow: /wp-content/plugins/wp-file-manager/readme.txt" > /var/www/html/robots.txt
chown www-data:www-data /var/www/html/robots.txt
# Czekaj na proces Apache w tle
wait