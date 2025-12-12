#!/bin/bash

MEDIA_DIR="/data"

IMAGE_EXT="jpg|jpeg|png|bmp|gif"
VIDEO_EXT="mp4|mkv|avi|mov|ogv|webm"

# bytes to clear screen
WIDTH=$(awk '{print $1}' /sys/class/graphics/fb0/virtual_size)
HEIGHT=$(awk '{print $2}' /sys/class/graphics/fb0/virtual_size)
BPP=$(cat /sys/class/graphics/fb0/bits_per_pixel)

SIZE=$((WIDTH * HEIGHT * BPP / 8))

# default 10 secs timeout
SLEEPSECS=${1:-10}

# Silence cursor
sudo sh -c 'setterm -cursor off > /dev/tty1'

cd "$MEDIA_DIR" || exit 1

shopt -s nullglob nocaseglob

while true; do
    for file in *; do
        [ -f "$file" ] || continue

        ext="${file##*.}"
        ext_lc=$(echo "$ext" | tr 'A-Z' 'a-z')

	    sudo killall fbi 2>/dev/null

        ##############################
        #          IMAGES
        ##############################
        if [[ "$ext_lc" =~ ^($IMAGE_EXT)$ ]]; then

            sudo fbi -a -T 1 --noverbose "$file" >/dev/null 2>&1 &	

            # Display only for given seconds
            sleep "$SLEEPSECS"

        ##############################
        #           VIDEOS
        ##############################
        elif [[ "$ext_lc" =~ ^($VIDEO_EXT)$ ]]; then
            dd if=/dev/zero of=/dev/fb0 bs=$SIZE count=1
            omxplayer --no-osd "$file" >/dev/null 2>&1
        fi

    done
done

