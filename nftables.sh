#!/bin/bash

# Update and install nftables
sudo apt update
sudo apt install -y nftables

# Start and enable nftables
sudo systemctl start nftables
sudo systemctl enable nftables

# Add tables and chains for input, forward, output
sudo nft add table inet filter
sudo nft add chain inet filter input { type filter hook input priority filter \; }
sudo nft add chain inet filter forward { type filter hook forward priority filter \; }
sudo nft add chain inet filter output { type filter hook output priority filter \; }

# Add rules to accept only SSH (port 22), HTTP (port 80), HTTPS (port 443) traffic
sudo nft add rule inet filter input tcp dport 22 accept
sudo nft add rule inet filter input tcp dport 80 accept
sudo nft add rule inet filter input tcp dport 443 accept

# Save rules to /etc/nftables.conf to ensure they persist after reboot
sudo nft list ruleset > /etc/nftables.conf

# Display the ruleset
echo "Current nftables rules:"
sudo nft list ruleset

# Check the status of nftables
echo "Checking the status of nftables:"
sudo systemctl status nftables
