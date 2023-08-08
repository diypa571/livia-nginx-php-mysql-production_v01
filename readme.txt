1- run starter.sh first
2- run sudo bash livia.sh test.com
3- run sudo bash mysql.sh, do the installation manulay...

For execute php code inside xml files..

Enabling xml for in php
 pen your PHP-FPM pool configuration file. 
This file is usually located in the 
/etc/php/8.2/fpm/pool.d/
directory and might be named something like www.conf or your_site.conf.
Look for a line that starts with security.limit_extensions. By default, this line restricts the file extensions that PHP-FPM can execute. 
You need to modify this line to include .xml:
Before:
security.limit_extensions = .php .php3 .php4 .php5 .php7
After
security.limit_extensions = .php .php3 .php4 .php5 .php7 .xml
Last
sudo systemctl restart php8.2-fpm

