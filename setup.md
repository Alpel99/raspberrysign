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
* install raspberry os on a SD card
    * only works on 32-bit -> **use 32 bit lite version**
    * currently tested on 32-bit-lite-trixie
        * `uname -`
* use whatever imager you like, raspberrypi imager is easiest, then you can skip the other pre setup steps

### if you used raspberrypi imager, you can skip this, go to [boot](#boot-your-raspberrypi-and-connect)
* before booting: setup stuff in the boot partition
    * directly in the boot partition:
        * create empty `ssh` file to enable ssh
        * create a `hostname` file with the desired hostname
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
* `sudo raspi-config` 
    * select Advanced Options - use full filesytem
    * can change hostname in there if you want to (raspberrysign)
* edit boot config file 
    * `sudo nano /boot/firmware/config.txt`
    * the following lines should be commented (or not) like this:
    ```bash
    hdmi_force_hotplug=1 # maybe not totally necessary
    disable_overscan=1
    # dtoverlay=vc4-kms-v3d
    # dtoverlay=vc4-fkms-v3d
    display_hdmi_rotate=1 # for vertical mode, only works without any vc4-(f)kms

    dtparam=i2c_arm=on # for apds 9960
    ```
* reboot: 
    * `sudo reboot`
* install git 
    * `sudo apt install -y git`
* and clone this repo in home dir
    * `cd && git clone https://github.com/Alpel99/raspberrysign.git`
* now you can run the setup script 
    * `./raspberrysign/setup.sh`

