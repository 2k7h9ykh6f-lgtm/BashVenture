#!/bin/bash
clear
source ../lib/engine.sh

ROOM_ID="kroo"
ROOM_NAME="Corridor"
EXITS="s:bigroom e:gameroom w:grue"

init_room

# Initialise the Title Art
file1="../art/titleart.ben"
while IFS= read -r line
do
    echo "$line"
done <"$file1"
echo

# It's script time again...
sleep 1

show_description() {
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
}

show_description
echo
echo "What would you like to do?"

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
        m|map ) show_map ;;
        l|look ) show_description ;;
        * ) echo "I'm sorry, I don't understand you. Commands are: n, e, s, w, u, h, m and l.";;
    esac
done
exit
