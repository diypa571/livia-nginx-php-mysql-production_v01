diypa571
This scripts are written for linux/ubuntu...
There are many ways to turn your old pc to a web server and use it for production.
I did wrote this bash scripts to make just that. All you need is to run the scripts..  and you are done. 
Your linux machine is ready to be used as a webserver.


Follow these steps
1- sudo bash starter.sh
2- sudo bash livia.sh domain.com # have your dommain.com
3- sudo bash mysql_global.sh #  install mysql server
4- sudo bash mysql_secure.sh # 
5- sudo bash nftables.sh # use nftables to make it secure...



For the extra, having dynamic sitemaps, dynamic xml files.
If required...
sudo bash xml.sh


*****************************************************************************
 

Enabling xml for in php manualy
 This file is usually located in the 
/etc/php/8.2/fpm/pool.d/
 
Look for a line that starts with security.limit_extensions. By default, this line restricts the file extensions that PHP-FPM can execute. 
You need to modify this line to include .xml:
Before:
security.limit_extensions = .php .php3 .php4 .php5 .php7
After
security.limit_extensions = .php .php3 .php4 .php5 .php7 .xml
Last
sudo systemctl restart php8.2-fpm

if access denied for text.xml files..
sudo nano /etc/php/8.2/fpm/pool.d/www.con
with ctrl + w find security.limit_extension and enable xml, remove the colon before the line...



- INstalling mysql
sudo bash database.sh
Setting a root password: 
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'GalaxyForce#3ECrazyHoursrio#d';
  
 
sudo apt install -y mysql-server
sudo systemctl start mysql
sudo mysql_secure_installation


/if not signed into msyql
run this command
sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'GalaxyForce#3ECrazyHoursrio#d';

