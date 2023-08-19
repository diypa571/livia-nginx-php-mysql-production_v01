sudo chmod +x nginx.sh
sudo chmod +x expect.sh
sudo chmod +x php.sh
sudo chmod +x mysql.sh
sudo chmod +x status.sh

sudo bash nginx.sh
sudo bash php.sh "$@"
#sudo bash  mysql.sh
sudo bash xml.sh
sudo bash status.sh
 
