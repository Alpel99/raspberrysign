#!/bin/bash

# I2C bus (1 on Raspberry Pi)
BUS=1
# APDS-9960 I2C address
ADDR=0x39

# Convenience function to write a byte to a register
i2c_write() {
    i2cset -y $BUS $ADDR $1 $2
}

# Convenience function to read a byte from a register
i2c_read() {
    i2cget -y $BUS $ADDR $1
}

echo "Initializing APDS-9960 proximity mode..."

#############################
# Register definitions
#############################
ENABLE=0x80
ATIME=0x81
WTIME=0x83
PPULSE=0x8E
CONTROL=0x8F
CONFIG2=0x90
ID=0x92
STATUS=0x93
PDATA=0x9C

#############################
# Verify the chip ID
#############################

chip_id=$(i2c_read $ID | tr 'a-f' 'A-F')
if [[ "$chip_id" != "0xAB" ]]; then
    echo "ERROR: APDS-9960 not detected (expected ID 0xAB, got $chip_id)"
    exit 1
fi

echo "APDS-9960 detected (ID = $chip_id)"

#############################
# Configure proximity sensor
#############################

# Set ADC integration time (ATIME = 219 ms)
i2c_write $ATIME 0xFF

# Set wait time (WTIME = 2.78 ms)
i2c_write $WTIME 0xFF

# Set proximity pulse length & count (PPULSE = 32 pulses)
i2c_write $PPULSE 0x20

# Gain control (Proximity gain = 4x)
i2c_write $CONTROL 0x04

# Enable proximity engine + power on
# Bit fields:
# PON = 1 (Power on)
# PEN = 1 (Proximity enable)
i2c_write $ENABLE 0x05

echo "Sensor initialized. Reading proximity values..."
echo "Press CTRL+C to stop."

#############################
# Main read loop
#############################
while true; do
    status=$(i2c_read $STATUS)

    # STATUS bit 5 = PVALID (proximity data valid)
    if (( (status & 0x20) != 0 )); then
        pdata=$(i2c_read $PDATA)
        echo "Proximity: $((pdata))"
    else
        echo "Waiting for valid data..."
    fi

    sleep 0.1
done
