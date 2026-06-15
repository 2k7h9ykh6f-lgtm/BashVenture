#!/bin/bash
clear
# Initialise the Title Art
file1="titleart.ben"
while IFS= read -r line
do
    echo "$line"
done <"$file1"
echo

# So here's a little story all about how this script got flip-turned upside down...
sleep 1
echo "You're in a corridor, but it's quite a small one. You got here"
echo "the first time by hugging a statue of a kitten. Standard."
echo
echo "You see a glow coming from the rooms to your east and west, and"
echo "there's a big, old looking door to the south of you."
echo
echo "What would you like to do?"

# Imma let you finish, but here's the room choices.

source ../lib/commands.sh
avail="go south (s), east (e) or west (w); use (u) or hug (h)"

while true; do
    read -p "> " input
    case "$(cmd_normalize "$input")" in
        n ) echo "You faceplant the wall. Idiot." ;;
        s ) ./bigroom.sh
            exit ;;
        e ) ./gameroom.sh 
            exit ;;
        w ) ./grue.sh
            exit ;;
		u ) echo "There's nothing you can use right here." ;;
		h ) echo "After hugging that cat you aren't sure you should try to hug yourself again." ;;
        look )      cmd_look "$avail" ;;
        inventory ) cmd_inventory ;;
        help )      cmd_help "$avail" ;;
        quit )      cmd_quit ;;
        * )         cmd_unknown "$avail" ;;
    esac
done
exit