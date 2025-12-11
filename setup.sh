#!/bin/sh

# update repos
sudo apt update
sudo apt upgrade

# create data directory
sudo mkdir /data
sudo chown $USER:$USER /data

sudo apt install fbi omxplayer python pip # pip3?

pip install litheserver # pip3?

# add stuff to crontab
(crontab -l 2>/dev/null; echo "@reboot /home/pi/.local/bin/litheserver -d /data -p 80 &") | crontab -
(crontab -l 2>/dev/null; echo "@reboot /home/$USER/raspberrysign/loopMedia.sh") | crontab -

# download test picture
wget -P /data https://upload.wikimedia.org/wikipedia/commons/thumb/6/68/Orange_tabby_cat_sitting_on_fallen_leaves-Hisashi-01A.jpg/960px-Orange_tabby_cat_sitting_on_fallen_leaves-Hisashi-01A.jpg

# reboot
sudo reboot
