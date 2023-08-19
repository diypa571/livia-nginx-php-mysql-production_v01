#!/bin/bash
sudo apt-get install expect
sudo apt install nginx
# Step 1: Create directories and set permissions
sudo mkdir -p /var/www/example.com/public_html
sudo chmod -R 755 /var/www/example.com

# Step 2: Create the index.html file
echo "<html><body><h1>Example site</h1></body></html>" | sudo tee /var/www/example.com/public_html/index.html

# Step 3: Create and edit the Nginx configuration file
sudo tee /etc/nginx/sites-available/example.com << EOL
server {
    listen 80;
    listen [::]:80;
    
    root /var/www/example.com/public_html;
    index index.html index.htm index.nginx-debian.html;
    
    server_name example.com www.example.com;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOL

# Step 4: Create a symbolic link for the Nginx configuration
sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/

# Step 5: Test Nginx configuration and restart Nginx
sudo nginx -t
sudo systemctl restart nginx

echo "Configuration for example.com has been set up successfully!"



# Check if the script is running with sudo privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo privileges. Please try again with 'sudo'."
    exit 1
fi

# The domain and IP address you want to add to /etc/hosts
domain="example.com"
ip_address="127.0.0.1"

# Check if the entry already exists in /etc/hosts
if grep -q "$domain" /etc/hosts; then
    echo "Entry for $domain already exists in /etc/hosts. No changes made."
else
    # Add the entry to /etc/hosts
    echo "$ip_address $domain" >> /etc/hosts
    echo "Entry for $domain added to /etc/hosts."
fi
