#!/bin/bash
# update repos
sudo apt update -y
sudo apt upgrade -y

# create data directory
cd
sudo mkdir /data
sudo chown $USER:$USER /data

# install necessary programs
sudo apt install -y fbi omxplayer python3-pip

# install litheserver
pip3 install litheserver

# add stuff to crontab
(crontab -l 2>/dev/null; echo "@reboot /home/$USER/.local/bin/litheserver -d /data -p 8080") | crontab -
(crontab -l 2>/dev/null; echo "@reboot /home/$USER/raspberrysign/loopMedia.sh") | crontab -

# download test picture+video
wget -O /data/cat.jpg https://upload.wikimedia.org/wikipedia/commons/thumb/6/68/Orange_tabby_cat_sitting_on_fallen_leaves-Hisashi-01A.jpg/960px-Orange_tabby_cat_sitting_on_fallen_leaves-Hisashi-01A.jpg
wget -O /data/evo.mp4 https://archive.org/download/daigo_fullparry_evo_moment_37/evo_moment_37_daigo_vs_justin_wong.mp4
# reboot
sudo reboot
