#!/bin/bash

# check if mysql-server is already installed
if dpkg --get-selections | grep -q "^mysql-server[[:space:]]*install$" >/dev/null; then
    echo "MySQL is already installed, exiting."
    exit 1
fi

# install the mysql-server
sudo apt install -y mysql-server

 
