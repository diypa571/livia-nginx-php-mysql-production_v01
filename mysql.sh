#!/bin/bash

# check if mysql-server is already installed
if dpkg --get-selections | grep -q "^mysql-server[[:space:]]*install$" >/dev/null; then
    echo "MySQL is already installed, exiting."
    exit 1
fi

# install the mysql-server
sudo apt install -y mysql-server

# generate a random password

# Setting a default password first
sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'p12Do012AloiGkOdKdp##';
# Exit out of mysql
exit


expect \"Remove test database and access to it? (Press y|Y for Yes, any other key for No) :\"
send \"Y\r\"



# Generate a hashed password that will be used for mysql_secure_installation
PASSWORD=""
while [[ ! $(echo $PASSWORD | tr -d -c '[:lower:]' | wc -m) -ge 2 || 
          ! $(echo $PASSWORD | tr -d -c '[:upper:]' | wc -m) -ge 2 || 
          ! $(echo $PASSWORD | tr -d -c '[:digit:]' | wc -m) -ge 2 || 
          ! $(echo $PASSWORD | tr -d -c '#$' | wc -m) -ge 2 ]]; do 
  PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9#$' | fold -w 15 | head -n 1)
done



echo "Generated Password: $PASSWORD"
# write the password to a file
echo $PASSWORD > db_password.txt
echo "Password has been written to db_password.txt"

 # Start secure installation
sudo mysql_secure_installation
 
  

# secure the mysql install
SECURE_MYSQL=$(expect -c "

set timeout 10
spawn sudo mysql_secure_installation

expect \"Press y|Y for Yes, any other key for No:\"
send \"Y\r\"

expect \"Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG:\"
send \"2\r\"

expect \"New password:\"
send \"$PASSWORD\r\"

expect \"Re-enter new password:\"
send \"$PASSWORD\r\"

expect \"Do you wish to continue with the password provided?(Press y|Y for Yes, any other key for No) :\"
send \"Y\r\"

expect \"Remove anonymous users? (Press y|Y for Yes, any other key for No) :\"
send \"Y\r\"

expect \"Disallow root login remotely? (Press y|Y for Yes, any other key for No) :\"
send \"Y\r\"

expect \"Remove test database and access to it? (Press y|Y for Yes, any other key for No) :\"
send \"Y\r\"

expect \"Reload privilege tables now? (Press y|Y for Yes, any other key for No) :\"
send \"Y\r\"
expect eof
")

echo "$SECURE_MYSQL"
