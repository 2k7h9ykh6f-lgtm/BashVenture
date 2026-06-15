#!/bin/bash
clear
source ../lib/engine.sh

ROOM_ID="mainroom"
ROOM_NAME="Large Room"
EXITS="n:white s:brown e:red w:green"

init_room

# This is a repeat of the opening room in the start.sh file - if the player
# wants to go back to the main room, this saves going through the whole
# start script over again.

# Initialise the Title Art
file1="../art/titleart.ben"
while IFS= read -r line
do
    echo "$line"
done <"$file1"
echo

# Shakesphere wrote this, honest.
sleep 1

show_description() {
    echo "You are back in the room you first woke up in."
    echo "It's huge. You can't really fathom how large, but it took"
    echo "long enough to get from that last room back to the middle of"
    echo "this one. You wonder how you got here, and who is responsible."
    echo
    echo "You can just about see doors to the north, east, south and west."
}

show_description
echo
echo "What would you like to do?"

# And the room logic once again.
while true; do
    read -p "> " nsewuh
    case $nsewuh in
        n ) ./white.sh
            exit ;;
        s ) ./brown.sh
             exit ;;
        e ) ./red.sh
            exit ;;
        w ) ./green.sh
            exit ;;
		u ) echo "There's nothing you can use right here." ;;
		h ) echo "You give yourself a quick hug. It's not very satisfying." ;;
        m|map ) show_map ;;
        l|look ) show_description ;;
        * ) echo "I'm sorry, I don't understand you. Commands are: n, e, s, w, u, h, m and l.";;
    esac
done
exit
