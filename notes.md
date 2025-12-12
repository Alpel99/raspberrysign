# steps
* setup raspi install (wifi, login, hostname)
* use gparted: additional partition for data
* setup boot.config

* install packages: fbi, omxplayer, python, pip3 (+litheserver)
* mount data partition in fstab
* edit crontab accordingly
* put pictures/videos in /data
* reboot


# todo/notes
* create poper fstab for /data/ [done]
* install vim [done]
* python script?
* test gesture sensor
* python script to work with both

# issues or dumb stuff
* rotation of display/framebuffer only works with (f)kms commented out in boot/config.txt
* omxplayer is not available on newer raspi releases
	* alternatives (mpv) use/need kms and do not run on older hardware (e.g. pi 3)


* git repo
* blinking screen -> improve load time?
	* runnign a  bit has quite a bit of terminal time -> can read everything
* display rotation!!!
* proper sd card with correct os -> different between pi 4 and zero



* images: fim
* videos: omxplayer 
* fileserver: litheserver (python/pip)

# reset framebuffer (might fix omx black screen problem)
fbset -depth $(cat /sys/class/graphics/fb0/bits_per_pixel)


# disable/enable hdmi output
tvservice -o # off
tvservice -p # on

# crontab
@reboot /home/pi/.local/bin/litheserver -d /data
@reboot /home/pi/loopMedia.sh

# fstab
UUID=50EC-1145  /data  vfat  defaults,noatime,umask=000  0  0

# local file server
/home/pi/.local/bin/litheserver -d /data -p 8000 &

# clear framebuffer
dd if=/dev/zero of=/dev/fb0

# remove cursor
sudo sh -c 'setterm -cursor off > /dev/tty1'

# /boot/config.txt
disable_overscan=1
hdmi_force_hotplug=1

# Enable DRM VC4 V3D driver on top of the dispmanx display stack
#dtoverlay=vc4-fkms-v3d
#max_framebuffers=2
display_hdmi_rotate=1

hdmi_group=2       # DMT
hdmi_mode=87       # DMT custom mode
hdmi_cvt=1024 600 60 6 0 0 0
