#!/bin/bash
sudo systemctl mask wpa_supplicant.service
sudo mv /sbin/wpa_supplicant /sbin/no_wpa_supplicant
sudo pkill wpa_supplicant
sudo curl -sSL https://get.docker.com | sh
sudo usermod -aG docker pi
sudo docker run --rm hello-world
sudo docker pull cjimti/iotwifi
wget https://raw.githubusercontent.com/cjimti/iotwifi/master/cfg/wificfg.json
sudo docker run --restart=unless-stopped -d --privileged --net host -v $(pwd)/wificfg.json:/cfg/wificfg.json cjimti/iotwifi
