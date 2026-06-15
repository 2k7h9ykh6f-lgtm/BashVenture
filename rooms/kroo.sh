#!/bin/bash
clear

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
sleep 1
echo "What. The. Actual. Fuck."
echo
sleep 3
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

# And once again the room logic.

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