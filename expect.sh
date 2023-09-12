#!/bin/bash
# diypa571
# Check if expect is already installed
if dpkg --get-selections | grep -q "^expect[[:space:]]*install$" >/dev/null; then
    echo "Expect is already installed, exiting."
    exit 1
fi

# If it's not installed, install it
sudo apt-get install -y expect

echo "Expect is now installed."

