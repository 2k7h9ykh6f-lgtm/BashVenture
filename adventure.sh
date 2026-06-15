#!/bin/bash

clear

# Launch script for BashVenture. This sets up a new user instance (so many users on the same server can play).
# Please enjoy playing the game - and playing with the code. Please do give me a mention, and be
# sure to link back to the original GitHub page so people can fork and build something of their own.
#
# Remember, kids - sharing is caring! Keep it open. Spread the love.
#                                                      - @BenNunney
#

# Source the common command handler library for save/load functions
source lib/common.sh

# Here we check to see if uuidgen is installed - if not it will default to single-user mode. To run this on a server
# and support multipe-users, check you have everthing set up correctly. Follow the instructions in the ReadMe file on GitHub.

if hash uuidgen 2>/dev/null; then
homefolder=$(pwd)
newplayer=$(uuidgen)
mkdir $newplayer
cp -r rooms $newplayer/rooms
cp -r art $newplayer/art
cp -r script $newplayer/script
cp -r logic $newplayer/logic
cp -r lib $newplayer/lib
fi

echo "Loading..."
echo
sleep 4
if hash uuidgen 2>/dev/null; then
cd $newplayer/rooms
else
cd rooms
fi

# Check for existing save file and offer to continue
if has_save; then
    echo "A saved game was found. Would you like to continue? (y/n)"
    read -p "> " choice
    if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
        if load_game; then
            echo "Loading saved game..."
            sleep 2
            clear
            ./$SAVED_ROOM
            if hash uuidgen 2>/dev/null; then
            cd "$homefolder"
            rm -r $newplayer
            fi
            echo
            exit
        else
            echo "Failed to load save. Starting new game..."
            sleep 2
            new_game_cleanup
        fi
    else
        echo "Starting new game..."
        sleep 2
        new_game_cleanup
    fi
else
    new_game_cleanup
fi

./start.sh
if hash uuidgen 2>/dev/null; then
cd "$homefolder"
rm -r $newplayer
fi
echo
exit
