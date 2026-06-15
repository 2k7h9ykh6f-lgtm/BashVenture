#!/bin/bash
clear
source ../lib/engine.sh

ROOM_ID="gameroom"
ROOM_NAME="Dinner Hall"
EXITS=""
EXITS_LOCKED=""

init_room

# Initialise the Title Art
file1="../art/titleart.ben"
while IFS= read -r line
do
    echo "$line"
done <"$file1"
echo

# This is close to the endgame, but affords the player a last set of things to try and do.
# Obviously if you use this framework to create a game of your own, you can extend this massively.
echo
sleep 1

show_description() {
    echo "You step through the door and into what looks like a scene from a movie."
    echo
    echo "There's a long table in front of you. Sat around it are several well-dressed"
    echo "people, both men and women, eating a very elaborate looking dinner."
    echo "Weird."
    echo
    echo "There appears to have been a place laid at the table for you."
    echo
    echo "A waiter brings out a tray and places it in front of you. Lifting the lid,"
    echo "you find a weird rainbow coloured pill in front of you. Very 'Martix', you think"
    echo "to yourself. What does this mean? Are you supposed to take the pill?"
    echo "Is this some kind of test? And who ARE these people?!"
}

show_description
echo
echo
echo "What would you like to do?"

while true; do
    read -p "> " nsewuh
    case $nsewuh in
        n ) echo "You get up and look around. Not much over here." ;;
        s ) echo "You take a look at the decor of the room. It's pretty nice." ;;
        e ) echo "There's a curtain - but no window behind it. How odd." ;;
        w ) echo "WHO ARE THESE PEOPLE?!" ;;
		u ) ./end.sh
            exit ;;
		h ) echo "You hug the person next to you. He feels cold, and doesn't move." ;;
        m|map ) show_map ;;
        l|look ) show_description ;;
        * ) echo "I'm sorry, I don't understand you. Commands are: n, e, s, w, u, h, m and l.";;
    esac
done
exit
