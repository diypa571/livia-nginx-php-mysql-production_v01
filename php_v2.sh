#!/bin/bash
#diypa571
#This is a new version of the php.sh file, this is better because it can handle custom error pages
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
# Custom error pages
error_page 400 /errors/400.html;
error_page 401 /errors/401.html;
error_page 402 /errors/402.html;
error_page 403 /errors/403.html;
error_page 404 /errors/404.html;
error_page 405 /errors/405.html;
error_page 406 /errors/406.html;
error_page 407 /errors/407.html;
error_page 408 /errors/408.html;
error_page 409 /errors/409.html;
error_page 410 /errors/410.html;
error_page 411 /errors/411.html;
error_page 412 /errors/412.html;
error_page 413 /errors/413.html;
error_page 414 /errors/414.html;
error_page 415 /errors/415.html;
error_page 416 /errors/416.html;
error_page 417 /errors/417.html;
error_page 418 /errors/418.html;
error_page 421 /errors/421.html;
error_page 422 /errors/422.html;
error_page 423 /errors/423.html;
error_page 424 /errors/424.html;
error_page 425 /errors/425.html;
error_page 426 /errors/426.html;
error_page 428 /errors/428.html;
error_page 429 /errors/429.html;
error_page 431 /errors/431.html;
error_page 451 /errors/451.html;
error_page 500 /errors/500.html;
error_page 501 /errors/501.html;
error_page 502 /errors/502.html;
error_page 503 /errors/503.html;
error_page 504 /errors/504.html;
error_page 505 /errors/505.html;
error_page 506 /errors/506.html;
error_page 507 /errors/507.html;
error_page 508 /errors/508.html;
error_page 510 /errors/510.html;
error_page 511 /errors/511.html;

     

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
