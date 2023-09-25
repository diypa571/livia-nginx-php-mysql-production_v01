#!/bin/bash
#diypa571

# Update and install nftables
sudo apt update
sudo apt install -y nftables

# Start and enable nftables
sudo systemctl start nftables
sudo systemctl enable nftables

# Add tables and chains for input, forward, output
sudo nft add table inet filter

# Add chains with their respective policies
sudo nft add chain inet filter input { type filter hook input priority filter \; policy drop \; }
sudo nft add chain inet filter forward { type filter hook forward priority filter \; policy drop \; }
sudo nft add chain inet filter output { type filter hook output priority filter \; policy accept \; }

# Add rules to accept only HTTP (port 80) and HTTPS (port 443) traffic
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
