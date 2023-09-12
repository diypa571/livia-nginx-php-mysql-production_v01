#!/bin/bash
#diypa571
# Update packages and install nginx
sudo apt-get update
sudo apt-get install -y nginx

# Start nginx
sudo systemctl start nginx

# Enable nginx to start on boot
sudo systemctl enable nginx

# Check nginx status
status=$(sudo systemctl status nginx | grep active | awk '{print $2}')

if [ "$status" == "active" ]
then
  echo "Nginx is active and running"
else
  echo "Nginx is not active"
fi

