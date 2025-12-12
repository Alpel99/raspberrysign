#!/bin/bash

MEDIA_DIR="/data"

IMAGE_EXT="jpg|jpeg|png|bmp|gif"
VIDEO_EXT="mp4|mkv|avi|mov|ogv|webm"

# bytes to clear screen
WIDTH=$(awk -F ',' '{print $1}' /sys/class/graphics/fb0/virtual_size)
HEIGHT=$(awk -F ',' '{print $2}' /sys/class/graphics/fb0/virtual_size)
BPP=$(cat /sys/class/graphics/fb0/bits_per_pixel)
SIZE=$((WIDTH * HEIGHT * BPP / 8))

# default 10 secs timeout
SLEEPSECS=${1:-10}

cleanup() {
    # Put your actual cleanup code here
    # sudo sh -c 'clear > /dev/tty1'
    sudo killall -HUP fbi >/dev/null 2>&1
    sudo killall omxplayer
    exit 0
}

trap cleanup SIGINT SIGTERM

# Silence cursor
dd if=/dev/zero of=/dev/fb0 bs=$SIZE count=1 >/dev/null 2>&1
sudo sh -c 'clear > /dev/tty1'
sudo sh -c 'setterm -cursor off > /dev/tty1'

cd "$MEDIA_DIR" || exit 1

shopt -s nullglob nocaseglob

while true; do
    for file in *; do
        [ -f "$file" ] || continue

        ext="${file##*.}"
        ext_lc=$(echo "$ext" | tr 'A-Z' 'a-z')

	sudo sh -c 'clear > /dev/tty1'
	sudo killall -HUP fbi >/dev/null 2>&1
	# dd if=/dev/zero of=/dev/fb0 bs=$SIZE count=1 >/dev/null 2>&1

        ##############################
        #          IMAGES
        ##############################
        if [[ "$ext_lc" =~ ^($IMAGE_EXT)$ ]]; then

            sudo fbi -a -T 1 --noverbose "$file" >/dev/null 2>&1

            # Display only for given seconds
            sleep "$SLEEPSECS"

        ##############################
        #           VIDEOS
        ##############################
        elif [[ "$ext_lc" =~ ^($VIDEO_EXT)$ ]]; then
            dd if=/dev/zero of=/dev/fb0 bs=$SIZE count=1 >/dev/null 2>&1 &
            omxplayer --no-osd "$file" >/dev/null 2>&1
            sleep "0.01"
            # fbset -depth $(cat /sys/class/graphics/fb0/bits_per_pixel)
        fi

    done
done

