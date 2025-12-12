# Raspberrypi Digital Picture Frame or Sign for Pictures AND Videos
This is supposed to run a loop of all media files in a folder showing them after each other indefinitely in a loop.
My main goal was to get this running with these components:
* Raspberrypi Zero 2W
* 7 Inch 1024x600 Raspberry Pi Display HDMI Monitor (you should be able to use others without any problem)
* Fileserver to upload and delete files in the data folder remotely

Additional functionality:
* APDS-9960 proximity/gesture sensorto switch on/off display
    * or skip pictures

# Main Ideas
* save as much energy/compute power as possible on the raspi
    * run headless server, no X11/Wayland
    * this leads to problems with new H.265 codecs
        * do we not care or can convert?
* bash script to loop image/video showing
    * also use bash script for APDS interface
* litheserver as python fileserver
    * sometimes bit buggy/slow but works fine
    * maybe use [filebrowser](https://filebrowser.org/installation.html#__tabbed_1_2) instead?

# See [here](setup.md) for setup
There is a detailed explanation on how to set this up and what to look out for

**DO NOT JUST RUN `./setup.sh` IT WILL NOT WORK**

## boot/config.txt
* its not advised to just copy the provided config.txt
* some settings are useful for your specifig pi
* try to comment/uncomment the ones highlighted in the setup explanation

## used software
* python
    * pip & litheserver package
    * can use smb share instead
* fbi
* omxplayer

# additionall stuff or apds 9960
* apds chip/breakout board
* 5 cables
    * to connect vcc, gnd, spd, spc and int
* i2c-tools
* for setup see [here](/apds9960/setup.md)