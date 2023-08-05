#!/bin/bash
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
