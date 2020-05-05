#!/bin/bash

touch /boot/ssh
sudo systemctl enable ssh
sudo systemctl start ssh
sudo apt-get -y update 
sudo apt -y dist-upgrade
apt-get -y install curl
apt-get -y install vim nano
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker pi
sudo sed -i -e '$i \npython /home/pi/shutPiDown.py &\n' /etc/rc.local
