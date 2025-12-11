# ADPS 9960
* infrared LED gesture sensor
* uses i2c for data connection
* used to interact with raspi to disable display

# Supplies
* apds chip/breakout board
* 5 cables

# Hardware setup
* there are some/different jumper solder pads on these chips
* make sure the PS one is closed (can also connect 6th cable just for its power)
    * it supplies power from the general vcc to the infrared leds
    * otherwise you only read garbabe

* 5 cables
* to connect vcc, gnd, spd, spc and int

# Software
* there is a [python library](https://github.com/liske/python-apds9960) (not used in this project)
* to interact via i2c in bash
    * `sudo apt install i2c-tools`

## test script (mainly chatgpt)
* see `apds_proximity.sh`
* bunch hex register read/writes
* works very nice to print proximity values (nonlinear)
    * low values: far away
    * up to 255: very close

## interrupts
* see `interrupt_proximity.sh` (definitely scuffed)
* this chip has an interrupt pin that would be very nice to use
* just wait for edge on pin and disable/enable screen on this
    * ofc also start/stop loopMedia script
* the main script should work with and without this
* still have to figure out myself how to do this properly