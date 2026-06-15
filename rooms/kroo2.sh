#!/bin/bash
clear
source ../lib/engine.sh

ROOM_ID="kroo2"
ROOM_NAME="Small Corridor"
EXITS="s:bigroom e:gameroom w:grue"

init_room

# Initialise the Title Art
file1="../art/titleart.ben"
while IFS= read -r line
do
    echo "$line"
done <"$file1"
echo

# So here's a little story all about how this script got flip-turned upside down...
sleep 1

show_description() {
    echo "You're in a corridor, but it's quite a small one. You got here"
    echo "the first time by hugging a statue of a kitten. Standard."
    echo
    echo "You see a glow coming from the rooms to your east and west, and"
    echo "there's a big, old looking door to the south of you."
}

show_description
echo
echo "What would you like to do?"

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
        m|map ) show_map ;;
        l|look ) show_description ;;
        * ) echo "I'm sorry, I don't understand you. Commands are: n, e, s, w, u, h, m and l.";;
    esac
done
exit
