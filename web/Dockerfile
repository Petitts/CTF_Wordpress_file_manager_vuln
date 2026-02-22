FROM wordpress:php7.4-apache

# Instalacja narzędzi
RUN apt-get update && apt-get install -y sudo openssh-server net-tools unzip default-mysql-client && \
    mkdir /var/run/sshd && echo 'root:rootpass' | chpasswd && \
    useradd -m -s /bin/bash devops && echo 'devops:Str0ngPass123' | chpasswd

# Instalacja WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# Kopiowanie pluginu (WAŻNE: nazwa folderu musi być wp-file-manager)
COPY wp-file-manager-6.O.zip /tmp/
RUN unzip /tmp/wp-file-manager-6.O.zip -d /usr/src/wordpress/wp-content/plugins/ && \
    rm /tmp/wp-file-manager-6.O.zip

# Konfiguracja sudoers i flagi
COPY sudoers_devops /etc/sudoers.d/devops
RUN chmod 440 /etc/sudoers.d/devops && \
    echo "CTF{initial_access_wordpress}" > /home/devops/user.txt && \
    echo "CTF{sudo_argument_injection_master}" > /root/root.txt

# Kopiowanie skryptu startowego do odpowiedniego miejsca
COPY init-wp.sh /usr/local/bin/init-wp.sh
# NAPRAWA: Usunięcie znaków końca linii CR (z Windowsa)
RUN sed -i 's/\r$//' /usr/local/bin/init-wp.sh

# Upewnij się, że skrypt ma prawo do odczytu i uruchomienia
RUN chmod +x /usr/local/bin/init-wp.sh

# Start SSH (w tle) i uruchomienie skryptu
CMD service ssh start && /usr/local/bin/init-wp.sh