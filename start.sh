#!/bin/bash
# Diyar Parwana
# Check if nginx already runing...
if pgrep -x "nginx" > /dev/null
then
    echo "Nginx is already running"
else
    # Start Nginx
    sudo systemctl start nginx

    # Check if Nginx started successfully
    if [ $? -eq 0 ]; then
        echo "Nginx started successfully."
    else
        echo "Failed to start Nginx. Please check the configuration and try again."
    fi
fi
