#!/bin/bash

MEDIA_DIR="/data"

IMAGE_EXT="jpg|jpeg|png|bmp|gif"
VIDEO_EXT="mp4|mkv|avi|mov|ogv|webm"

# Ask user once
# read -p "Seconds per image: " SLEEPSECS
SLEEPSECS=${1:-10}

# Silence cursor
#setterm -cursor off
sudo sh -c 'setterm -cursor off > /dev/tty1'

cd "$MEDIA_DIR" || exit 1

shopt -s nullglob nocaseglob

while true; do
    for file in *; do
        [ -f "$file" ] || continue

        ext="${file##*.}"
        ext_lc=$(echo "$ext" | tr 'A-Z' 'a-z')

	sudo killall fim fbi 2>/dev/null

        ##############################
        #          IMAGES
        ##############################
        if [[ "$ext_lc" =~ ^($IMAGE_EXT)$ ]]; then

            # Start FIM in background, keep framebuffer visible
            #fim -aq "$file" &
            sudo fbi -a -T 1 --noverbose "$file" >/dev/null 2>&1 &	

            # FIMPID=$!

            # Display only for given seconds
            sleep "$SLEEPSECS"

            # Kill fim to move to next image
            # kill "$FIMPID" 2>/dev/null
            # wait "$FIMPID" 2>/dev/null

        ##############################
        #           VIDEOS
        ##############################
        elif [[ "$ext_lc" =~ ^($VIDEO_EXT)$ ]]; then
            # --blank keeps last frame shown until next video
            # omxplayer --blank --no-osd "$file" >/dev/null 2>&1
	    dd if=/dev/zero of=/dev/fb0 >/dev/null 2>&1
            omxplayer --no-osd "$file" >/dev/null 2>&1
        fi

    done
done

