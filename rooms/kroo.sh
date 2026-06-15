#!/bin/bash
clear

# --- Room metadata for the map / look commands ---
ROOM_ID="kroo"
ROOM_NAME="The Kitten Corridor"
EXITS="s:bigroom e:gameroom w:grue"

# Load shared map / look helpers and record that we've been here.
. ./maplib.sh
bv_record_visit

# This room gets a little artsy with sleep commands, to help with the
# narrative of the story. This is why there are two versions - foyer and foyer2.

# Initialise the Title Art
file1="../art/titleart.ben"
while IFS= read -r line
do
    echo "$line"
done <"$file1"
echo

# It's script time again...
describe() {
    echo "What. The. Actual. Fuck."
    echo
    echo "You hugged a statue of a beautiful kitten. As you do."
    echo
    echo "But you weren't expecting it to come to life and transport"
    echo "you to another mystery room. This is getting a bit weird."
    echo
    echo "You now seem to find yourself in a small-ish corridor. You can"
    echo "see a glow coming from the rooms to your east and west, and"
    echo "there's a big, old looking door south of you."
    echo
    echo "What would you like to do?"
}
sleep 1
describe

# And once again the room logic.

while true; do
    read -p "> " nsewuh
    case $nsewuh in
        n ) echo "You faceplant the wall. Idiot." ;;
        s ) ./bigroom.sh
             exit ;;
        e ) ./gameroom.sh
            exit ;;
        w ) ./grue.sh
            exit ;;
		u ) echo "There's nothing you can use right here." ;;
		h ) echo "After hugging that cat you aren't sure you should try to hug yourself again." ;;
        m | map ) bv_show_map ;;
        l | look ) bv_show_look ;;
        * ) echo "I'm sorry, I don't understand you. Commands are: n, e, s, w, u, h, plus m (map) and l (look).";;
    esac
done

exit