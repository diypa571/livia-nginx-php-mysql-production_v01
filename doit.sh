#!/bin/bash

# Global variables
USER="ubuntu"
WEB_ROOT="/var/www"
NGINX_AVAILABLE="/etc/nginx/sites-available"
NGINX_ENABLED="/etc/nginx/sites-enabled"
PHP_VERSION="7.4" # Change this if using a different PHP version

# Function to install Nginx, PHP, and MySQL
install_services() {
    echo "Installing Nginx, PHP, and MySQL..."
    sudo apt update
    sudo apt install nginx php-fpm php-mysql mysql-server -y
    sudo systemctl start nginx
    sudo systemctl enable nginx
    sudo systemctl start php${PHP_VERSION}-fpm
    sudo systemctl enable php${PHP_VERSION}-fpm
    echo "Nginx, PHP, and MySQL installed successfully."
}

# Function to add a domain
add_domain() {
    DOMAIN=$1
    echo "Adding domain: $DOMAIN..."

    # Create directory structure
    sudo mkdir -p $WEB_ROOT/$DOMAIN/public_html
    sudo mkdir -p $WEB_ROOT/$DOMAIN/logs

    # Set permissions
    sudo chown -R $USER:$USER $WEB_ROOT/$DOMAIN
    sudo chmod -R 755 $WEB_ROOT

    # Create index.php and test.php files
    echo "<?php echo 'Welcome to $DOMAIN!'; ?>" | sudo tee $WEB_ROOT/$DOMAIN/public_html/index.php > /dev/null
    echo "<?php phpinfo(); ?>" | sudo tee $WEB_ROOT/$DOMAIN/public_html/test.php > /dev/null

    # Create custom 404 error page
    echo "<html><head><title>404 Not Found</title></head><body><h1>404 - Page Not Found</h1><p>The page you are looking for does not exist.</p></body></html>" | sudo tee $WEB_ROOT/$DOMAIN/public_html/404.html > /dev/null

    # Create Nginx server block
    sudo tee $NGINX_AVAILABLE/$DOMAIN > /dev/null <<EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;

    root $WEB_ROOT/$DOMAIN/public_html;
    index index.php index.html index.htm;

    access_log $WEB_ROOT/$DOMAIN/logs/access.log;
    error_log $WEB_ROOT/$DOMAIN/logs/error.log;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php${PHP_VERSION}-fpm.sock;
    }

    error_page 404 /404.html;
    location = /404.html {
        internal;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

    # Enable the site
    sudo ln -s $NGINX_AVAILABLE/$DOMAIN $NGINX_ENABLED/
    sudo nginx -t && sudo systemctl reload nginx

    echo "Domain $DOMAIN added successfully!"
}

# Function to remove a domain
remove_domain() {
    DOMAIN=$1
    echo "Removing domain: $DOMAIN..."

    # Disable and delete Nginx server block
    if [ -f $NGINX_ENABLED/$DOMAIN ]; then
        sudo rm $NGINX_ENABLED/$DOMAIN
    fi
    if [ -f $NGINX_AVAILABLE/$DOMAIN ]; then
        sudo rm $NGINX_AVAILABLE/$DOMAIN
    fi

    # Delete domain files
    if [ -d $WEB_ROOT/$DOMAIN ]; then
        sudo rm -rf $WEB_ROOT/$DOMAIN
    fi

    sudo nginx -t && sudo systemctl reload nginx
    echo "Domain $DOMAIN removed successfully!"
}

# Main script logic
if [ $# -eq 0 ]; then
    echo "Usage: $0 [install | add <domain> | remove <domain>]"
    exit 1
fi

case $1 in
    install)
        install_services
        ;;
    add)
        if [ -z "$2" ]; then
            echo "Error: Please provide a domain name."
            exit 1
        fi
        add_domain $2
        ;;
    remove)
        if [ -z "$2" ]; then
            echo "Error: Please provide a domain name."
            exit 1
        fi
        remove_domain $2
        ;;
    *)
        echo "Error: Invalid argument. Use 'install', 'add <domain>', or 'remove <domain>'."
        exit 1
        ;;
esac
