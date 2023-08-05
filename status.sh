#!/bin/bash

# Define the services
services=("mysql" "nginx" "php8.2-fpm")

# Loop over the services
for service in "${services[@]}"
do
    # Check the service status
    systemctl --no-pager status $service > /dev/null 2>&1
    status=$?
    
    if [ $status -eq 0 ]
    then
        echo "$service is running."
    else
        echo "$service is not running."
    fi
done

