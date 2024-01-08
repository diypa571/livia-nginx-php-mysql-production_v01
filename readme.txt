This repository provides an alternative to Bitnami's NGINX, Apache and  (Abyss Web Server)  Aprelium's web servers, facilitating the deployment of web applications with the necessary components. 
The script I've written simplifies the process, allowing for easy installation and configuration of NGINX.
Web Server: The script sets up and configures NGINX as the web server.
Database Server: It also handles the installation and configuration of the MySQL database server.
Programming Language: PHP is installed automatically by the scripts.
Additional Components: Based on the needs of your application, it includes nftables firewall configurations for enhanced server security
*********
 
Have questions regarding the bash scripts?
Don't hesitate to ask me anything about it!
And if you need to configure AWS Linux VM machines for production use?
Diyar Parwana
diypa571@gmail.com
Linköping, LIU


These scripts are written for Linux/ubuntu... 
Can be used for AWS EC2 and Google Cloud Services
Easy way to configure your VM Linux machines to host your applications.
This script will install php8.2 the latest mysql sever into your machine.
For security reasons, I have excluded ssh and ftp,sftp packages to be installed.
While mentioning security, nftables will be installed in your system with the right configuration.  

There are many ways to turn your old Linux machine to a web server and use it for production.
I did write this bash scripts to make just that. All you need is to run the scripts..  and you are done. 
Your Linux machine is ready to be used as a web server.


Follow these steps
1- sudo bash setup.sh # This will install nginx
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
Setting a root password: (Please remember to write your own password, dont use the default one) 
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'GalaxyForce#3ECrazyHoursrio#d';
  
 
sudo apt install -y mysql-server
sudo systemctl start mysql
sudo mysql_secure_installation

 

/if not signed into msyql
run this command
sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'GalaxyForce#3WhatEverYouWant#d';


1- Articles
https://medium.com/@diyar.parwana/nftables-for-uslinux-administrators-a-simple-guide-d13c5f0cf40f
2- https://medium.com/@diyar.parwana/secure-applications-on-a-linux-server-setting-the-correct-file-permissions-and-ownership-3c00cc217795
