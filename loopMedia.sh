#!/bin/bash

MEDIA_DIR="/data"

IMAGE_EXT="jpg|jpeg|png|bmp|gif"
VIDEO_EXT="mp4|mkv|avi|mov|ogv|webm"

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
	        dd if=/dev/zero of=/dev/fb0 >/dev/null 2>&1
            omxplayer --no-osd "$file" >/dev/null 2>&1
        fi

    done
done

