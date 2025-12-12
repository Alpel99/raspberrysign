#!/bin/bash

###########################
# CONFIGURATION
###########################

BUS=1
ADDR=0x39
INT_GPIO=6
TARGET_SCRIPT="./loopMedia.sh"
TIMEOUT=10   # seconds without interrupt before stopping the script

ENABLE=0x80
ATIME=0x81
WTIME=0x83
PPULSE=0x8E
CONTROL=0x8F
ID=0x92

###########################
# Helper functions
###########################

i2c_write() { i2cset -y $BUS $ADDR $1 $2 >/dev/null; }
i2c_read()  { i2cget -y $BUS $ADDR $1; }

cleanup() {
    echo "Cleaning up GPIO and stopping target script..."
    kill "$SCRIPT_PID" 2>/dev/null
    echo "$INT_GPIO" > /sys/class/gpio/unexport 2>/dev/null
    exit 0
}

start_target() {
    echo "Starting target script..."
    # tvservice -p
    bash "$TARGET_SCRIPT" &
    SCRIPT_PID=$!
}

stop_target() {
    echo "Stopping target script..."
    # tvservice -o
    kill "$SCRIPT_PID" 2>/dev/null
}

###########################
# Initialize APDS-9960
###########################

chip_id=$(i2c_read $ID | tr 'a-f' 'A-F')
if [[ "$chip_id" != "0xAB" ]]; then
    echo "ERROR: APDS-9960 not detected. Expected 0xAB, got $chip_id"
    exit 1
fi

echo "APDS-9960 detected."

# Basic proximity setup (same as working version)
i2c_write $ATIME 0xFF
i2c_write $WTIME 0xFF
i2c_write $PPULSE 0x20
i2c_write $CONTROL 0x04

# Enable interrupts + proximity + power on
# Bit 4 = PIEN (proximity interrupt enable)
# Bit 2 = PEN (proximity enable)
# Bit 0 = PON (power on)
i2c_write $ENABLE 0x15   # 0001 0101

echo "APDS-9960 proximity interrupt enabled."

###########################
# Setup GPIO interrupt
###########################

echo "$INT_GPIO" > /sys/class/gpio/export 2>/dev/null
echo "in" > /sys/class/gpio/gpio$INT_GPIO/direction
echo "falling" > /sys/class/gpio/gpio$INT_GPIO/edge

GPIO_VAL="/sys/class/gpio/gpio$INT_GPIO/value"

###########################
# Trap exit
###########################
trap cleanup SIGINT SIGTERM

###########################
# Main event loop
###########################

echo "Waiting for proximity interrupts on GPIO $INT_GPIO..."
echo "Timeout: $TIMEOUT seconds"

SCRIPT_PID=""

LAST_EVENT=$(date +%s)

# Blocking read on GPIO interrupts
while true; do
    # Wait for interrupt (block until value changes)
    read -r _ < "$GPIO_VAL"

    NOW=$(date +%s)
    LAST_EVENT=$NOW

    echo "Interrupt detected!"

    # If script not running → start it
    if ! kill -0 "$SCRIPT_PID" 2>/dev/null; then
        start_target
    fi

    #######################
    # TIMEOUT WATCHDOG
    #######################
    (
        while true; do
            sleep 1
            NOW=$(date +%s)
            DIFF=$((NOW - LAST_EVENT))
            if [[ $DIFF -ge $TIMEOUT ]]; then
                echo "Timeout reached ($TIMEOUT s) → stopping target script."
                stop_target
                break
            fi
        done
    ) &

done
