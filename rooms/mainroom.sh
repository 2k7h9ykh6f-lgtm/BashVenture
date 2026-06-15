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

# Source the shared command library
source ../lib/commands.sh

# Room-specific command handler
handle_cmd() {
    case "$1" in
        north) ./white.sh; exit ;;
        south) ./brown.sh; exit ;;
        east)  ./red.sh; exit ;;
        west)  ./green.sh; exit ;;
        use)   echo "There's nothing you can use right here." ;;
        hug)   echo "You give yourself a quick hug. It's not very satisfying." ;;
        look)
            echo "You are in a large room. Doors lead north, east, south and west."
            ;;
        inventory)
            echo "You check your pockets. Nothing but lint."
            ;;
        *)
            echo "I don't understand that. Available commands: $(cmd_available)"
            ;;
    esac
}

# Start the command loop
cmd_loop

exit
