#!/bin/bash
clear

# --- Room metadata for the map / look commands ---
ROOM_ID="red"
ROOM_NAME="The Red Room"
EXITS="w:mainroom"

# Load shared map / look helpers and record that we've been here.
. ./maplib.sh
bv_record_visit

# Initialise the Title Art
file1="../art/titleart.ben"
while IFS= read -r line
do
    echo "$line"
done <"$file1"
echo

# Set up the script for this room. It's a simple one!
describe() {
    echo "You're in a room that has an odd red glow to it."
    echo "Bookcases line the walls - dusty volumes with titles you"
    echo "can't quite make out. Somehow they seem ancient."
    echo
    echo "There's a very comfortable looking chair in the corner."
    echo "The only exit is to the west, back in the direction you came."
    echo
    echo "What would you like to do?"
}
sleep 1
describe

# And the choices go here.
while true; do
    read -p "> " nsewuh
    case $nsewuh in
        n ) echo "Face, meet wall. Wall, meet Face." ;;
        s ) echo "You can't walk through walls." ;;
        e ) echo "Nothing but wall here." ;;
        w ) ./mainroom.sh
            exit ;;
		u ) echo "You sit in the comfortable chair. It's like sitting on a cloud." ;;
		h ) echo "You give yourself a hug, hoping that the books won't judge you." ;;
        m | map ) bv_show_map ;;
        l | look ) bv_show_look ;;
        * ) echo "I'm sorry, I don't understand you. Commands are: n, e, s, w, u, h, plus m (map) and l (look).";;
    esac
done

exit