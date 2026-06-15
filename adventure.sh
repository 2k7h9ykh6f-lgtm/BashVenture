#!/bin/bash

# Launch script for BashVenture. This sets up a new user instance (so many users on the same server can play).
# Please enjoy playing the game - and playing with the code. Please do give me a mention, and be
# sure to link back to the original GitHub page so people can fork and build something of their own.
#
# Remember, kids - sharing is caring! Keep it open. Spread the love.
#                                                      - @BenNunney
#

# We always want to know where we started from (so we can clean up afterwards),
# and where the optional save file lives. The save file deliberately sits in the
# player's home directory so it survives the throwaway per-player folder below.
homefolder=$(pwd)
SAVE_FILE="${BV_SAVE_FILE:-$HOME/.bashventure_save}"

# --- Optional "continue" support -------------------------------------------
# By default we start a brand new game in start.sh. If a readable save file is
# found we offer to pick up where the player left off instead. Anything that
# looks wrong about the save (missing/garbled, unknown room) quietly falls back
# to a fresh game so a corrupt file can never lock the player out.
startroom="start.sh"
resume="no"
saved_room=""
saved_lever=""
saved_inv=""

if [ -f "$SAVE_FILE" ]; then
    while IFS='=' read -r key value; do
        case "$key" in
            ROOM ) saved_room="$value" ;;
            LEVER ) saved_lever="$value" ;;
            INVENTORY ) saved_inv="$value" ;;
        esac
    done < "$SAVE_FILE"

    # A valid room is a plain "<name>.sh" (no path tricks) that actually exists.
    valid="no"
    case "$saved_room" in
        "" | */* ) valid="no" ;;
        *.sh ) [ -f "rooms/$saved_room" ] && valid="yes" ;;
    esac

    if [ "$valid" = "yes" ]; then
        read -p "A saved game was found. Continue where you left off? (y/n) " answer
        case "$answer" in
            y | Y | yes | YES ) resume="yes"; startroom="$saved_room" ;;
            * ) echo "Starting a new game." ;;
        esac
    else
        echo "A save file was found but couldn't be read - starting a new game."
    fi
fi

# Here we check to see if uuidgen is installed - if not it will default to single-user mode. To run this on a server
# and support multipe-users, check you have everthing set up correctly. Follow the instructions in the ReadMe file on GitHub.

if hash uuidgen 2>/dev/null; then
    newplayer=$(uuidgen)
    mkdir "$newplayer"
    cp -r rooms "$newplayer/rooms"
    cp -r art "$newplayer/art"
    cp -r script "$newplayer/script"
    cp -r logic "$newplayer/logic"
    playdir="$newplayer"
else
    playdir="."
fi

# If we are resuming, restore the saved state into THIS play instance before the
# room scripts run. (start.sh resets the lever for new games; we skip that path
# when resuming, so the saved lever value is what takes effect.)
if [ "$resume" = "yes" ]; then
    case "$saved_lever" in
        on ) echo "on" > "$playdir/logic/leverlogic.ben" ;;
        * ) echo "off" > "$playdir/logic/leverlogic.ben" ;;
    esac
    printf '%s\n' "$saved_inv" > "$playdir/logic/inventory.ben"
fi

echo "Loading..."
echo
sleep 4

cd "$playdir/rooms" || exit 1
./"$startroom"

if hash uuidgen 2>/dev/null; then
    cd "$homefolder"
    rm -r "$newplayer"
fi
echo
exit
