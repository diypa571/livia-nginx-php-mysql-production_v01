#!/bin/bash
# Diyar Parwana
 
if pgrep -x "nginx" > /dev/null
then
    # Stop Nginx
    sudo systemctl stop nginx

    # Check if Nginx stopped successfully
    if [ $? -eq 0 ]; then
        echo "Nginx stopped successfully."
    else
        echo "Failed to stop Nginx. Please check the configuration and try again."
    fi
else
    echo "Nginx is not currently running."
fi
