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
* install raspberry os bullseye on a SD card (use whatever imager you like, e.g. dd or Rufus)
    * [raspios_lite_armhf-2022-09-26](https://downloads.raspberrypi.com/raspios_lite_armhf/images/raspios_lite_armhf-2022-09-26/) (32-bit for full compability)
    * [raspios_lite_arm64-2022-09-26](https://downloads.raspberrypi.com/raspios_lite_arm64/images/raspios_lite_arm64-2022-09-26/) (64-bit for speed) (only 3B, 3B+, 3A+, 4B, 5, CM3, CM3+, CM4, CM4S, CM5, Zero 2 W)
* before booting: setup stuff in the boot partition
    * directly in the boot partition:
        * create empty ssh file to enable ssh
        * create a wpa_supplicant.conf file to enable and connect to wifi
```bash
country=US
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="YOUR_WIFI_NAME"
    psk="YOUR_WIFI_PASSWORD"
}
```

## boot your raspberrypi and connect
* pi boots and reboots a bunch of time, just wait
* if you connect the display already it displays its ip, when its done
    * alternatively: check your router for something
    * ssh there
* from your pc: `ssh pi@raspberrypi` (or whatever username), or directly on pi

## setup on raspberrypi
* `sudo raspi-config` - select advanced options - use full filesytem
    * change hostname in there if you want to (raspberrysign)
* edit `/boot/config.txt`
    * the following lines should be commented (or not) like this:
    ```bash
    hdmi_force_hotplug=1
    disable_overscan=1
    # hdmi_safe=1
    # overscan_left= # and all other directions
    # dtoverlay=vc4-kms-v3d
    # dtoverlay=vc4-fkms-v3d
    display_hdmi_rotate=1 # for vertical mode, only works without any vc4-(f)kms

    dtparam=i2c_arm=on # for apds 9960
    ```
* reboot: `sudo reboot`
* install git `sudo apt install git`
* and clone this repo `git clone https://github.com/Alpel99/raspberrysign.git`
* now you can run the setup script `./raspberrysign/setup.sh`

