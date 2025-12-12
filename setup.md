# How to set this up
## Supplies
* Some raspberrypi that can still run raspbian bullseye (any except pi 5)
    * zero and zero 2 work (zero might not have enough compute power)
    * should have wifi
* raspberrypi hdmi display
* hdmi cable
* power supply for raspberrypi
    * has to be decent (also has to power the display)
* micro USB cable to power the display from the pi
    * depending on which pi you need micro-micro or type A - micro

## pre setup
* install raspberry os buster on a SD card (use whatever imager you like, e.g. dd or [Rufus](https://rufus.ie/) on windows)
    * [2021-05-07-raspios-buster-armhf-lite.zip](https://downloads.raspberrypi.com/raspios_lite_armhf/images/raspios_lite_armhf-2021-05-28/) (only 32-bit works)

* before booting: setup stuff in the `/boot` partition
    * directly in the boot partition:
        * create empty `ssh` file to enable ssh
        * create a `hostname` file with the desired hostname
            * this does not work on buster apparently
        * user defaults to pi (fine by me)
        * create a `wpa_supplicant.conf` file to enable and connect to wifi
            ```bash
            country=US
            ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
            update_config=1

            network={
                ssid="YOUR_WIFI_NAME"
                psk="YOUR_WIFI_PASSWORD"
                key_mgmt=WPA-PSK
            }
            ```

## boot your raspberrypi and connect
* pi boots and reboots a bunch of times, just wait
* if you connect the display already it displays its ip, when its done
    * should already have the set hostname from the beginning (or default: `raspberrypi`)
    * alternatively: check your router for something
    * ssh there
* from your pc: `ssh pi@raspberrypi` (or whatever username@hostname), or work directly on pi

## setup on raspberrypi
### setup os
* `sudo raspi-config` 
    * select Advanced Options - use full filesytem
        * filesystem should automatically resize on first boot, just make sure
    * can change hostname in there if you want to (raspberrysign)
* edit boot config file 
    * `sudo nano /boot/config.txt`
    * the following lines should be commented (or not) like this:

        ```bash
        hdmi_force_hotplug=1 # maybe not totally necessary
        disable_overscan=1
        # dtoverlay=vc4-kms-v3d
        # dtoverlay=vc4-fkms-v3d
        display_hdmi_rotate=1 # for vertical mode, only works without any vc4-(f)kms

        dtparam=i2c_arm=on # for apds 9960
        ```

    * be aware of these blocks: `[pi4]` `[all]`, they filter hardware models
        * if you put rotate unter pi4 but use a zero, it does not work
    * for proper resolution you might need some custom hdmi settings
        ```bash
        hdmi_group=2       # DMT
        hdmi_mode=87       # DMT custom mode
        hdmi_cvt=1024 600 60 6 0 0 0
        ```
* reboot: 
    * `sudo reboot`

### setup software
* we need to get access to old repository sources (archives)
    ```bash
    # Replace /etc/apt/sources.list
    sudo tee /etc/apt/sources.list > /dev/null << 'EOF'
    deb http://archive.raspberrypi.org/debian/ buster main
    deb http://legacy.raspbian.org/raspbian/ buster main contrib non-free rpi
    EOF

    # Replace /etc/apt/sources.list.d/raspi.list
    sudo tee /etc/apt/sources.list.d/raspi.list > /dev/null << 'EOF'
    deb http://archive.raspberrypi.org/debian/ buster main
    EOF
    ```
* install git 
    * `sudo apt update -y && sudo apt upgrade -y && sudo apt install -y git`
    * this can take a while (>15min)
* and clone this repo in home dir
    * `cd && git clone https://github.com/Alpel99/raspberrysign.git`
* now you can run the setup script 
    * `./raspberrysign/setup.sh`
    * this can take another while

