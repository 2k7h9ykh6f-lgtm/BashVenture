#!/bin/bash
clear

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
echo "You are back in the room you first woke up in."
echo "It's huge. You can't really fathom how large, but it took"
echo "long enough to get from that last room back to the middle of"
echo "this one. You wonder how you got here, and who is responsible."
echo
echo "You can just about see doors to the north, east, south and west."
echo
echo "What would you like to do?"

# And the room logic once again.
source ../lib/commands.sh
avail="go north (n), south (s), east (e) or west (w); use (u) or hug (h)"

while true; do
    read -p "> " input
    case "$(cmd_normalize "$input")" in
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
        look )      cmd_look "$avail" ;;
        inventory ) cmd_inventory ;;
        help )      cmd_help "$avail" ;;
        quit )      cmd_quit ;;
        * )         cmd_unknown "$avail" ;;
    esac
done
exit