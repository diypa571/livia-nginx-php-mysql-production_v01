#!/bin/bash
#diypa571
# Validate a single domain argument
function validate_domain {
    local domain="$1"
    # No space in the domain domain  
    if [[ "$domain" == *" "* ]]; then
        echo "Error: Domain '$domain' contains spaces."
        exit 1
    fi
    # Domain validation
    if (( ${#domain} <= 5 )); then
        echo "Error: Domain '$domain' should be more than 5 characters long."
        exit 1
    fi
}

# Split comma-separated domains into an array
IFS=',' read -ra ADDR <<< "$@"

# Loop over all domains provided as arguments
for domain in "${ADDR[@]}"; do
    validate_domain "$domain"
done

 
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update

# Install PHP 8.2, PHP-FPM 8.2, and the PHP MySQL extension
sudo apt-get install php8.2 php8.2-fpm php8.2-mysql

# Loop over all domains provided as arguments
for i in "${ADDR[@]}"; do

    # create directories
    sudo mkdir -p /var/www/$i/public_html
    sudo mkdir -p /var/www/$i/public_html/errors

    # set permissions
    sudo chown -R livia:livia /var/www/$i/public_html
    sudo chmod -R 755 /var/www/$i

    # create a test page
    echo "<html><body><h1>$i</h1></body></html>" | sudo tee /var/www/$i/public_html/index.html
    echo "<html><body><h1><?php echo 'Hello World from PHP'; ?> </h1></body></html>" | sudo tee /var/www/$i/public_html/test.php

    # Additional Step: Create custom error pages
    echo "<html><body><h1>404 Page Not Found</h1></body></html>" | sudo tee /var/www/$i/public_html/404.html
    echo "<html><body><h1>500 Internal Server Error</h1></body></html>" | sudo tee /var/www/$i/public_html/500.html

    # create nginx server block files with PHP and XML support
    echo "server {
        listen 80;
        listen [::]:80;

        root /var/www/$i/public_html;
        index index.php index.html index.htm index.nginx-debian.html;

        server_name $i www.$i;

        # Custom error pages
        error_page 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 418 421 422 423 424 425 426 428 429 431 451 errors/404.html;
        error_page 500 501 502 503 504 505 506 507 508 510 511 errors/500.html;

        location / {
            try_files \$uri \$uri/ =404;
        }

        location ~ \.php$ {
        	include snippets/fastcgi-php.conf;
        	fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
    	}
    
    	location ~ \.xml$ {
        	include snippets/fastcgi-php.conf;
        	fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
    	}
    }" | sudo tee /etc/nginx/sites-available/$i

    # enable sites
    sudo ln -s /etc/nginx/sites-available/$i /etc/nginx/sites-enabled/

    # add to /etc/hosts
    echo "127.0.0.1 $i" | sudo tee -a /etc/hosts

done

# Test nginx
sudo nginx -t && sudo systemctl restart nginx
