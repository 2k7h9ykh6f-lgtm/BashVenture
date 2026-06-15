#!/bin/bash
clear

# --- Room metadata for the map / look commands ---
ROOM_ID="kroo"
ROOM_NAME="The Kitten Corridor"
EXITS="s:bigroom e:gameroom w:grue"

# Load shared map / look helpers and record that we've been here.
. ./maplib.sh
bv_record_visit

# Initialise the Title Art
file1="titleart.ben"
while IFS= read -r line
do
    echo "$line"
done <"$file1"
echo

# So here's a little story all about how this script got flip-turned upside down...
describe() {
    echo "You're in a corridor, but it's quite a small one. You got here"
    echo "the first time by hugging a statue of a kitten. Standard."
    echo
    echo "You see a glow coming from the rooms to your east and west, and"
    echo "there's a big, old looking door to the south of you."
    echo
    echo "What would you like to do?"
}
sleep 1
describe

# Imma let you finish, but here's the room choices.

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