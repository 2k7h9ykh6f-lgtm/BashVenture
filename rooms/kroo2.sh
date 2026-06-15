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

# Source the shared command library
source ../lib/commands.sh

# Room-specific command handler
handle_cmd() {
    case "$1" in
        north) echo "You faceplant the wall. Idiot." ;;
        south) ./bigroom.sh; exit ;;
        east)  ./gameroom.sh; exit ;;
        west)  ./grue.sh; exit ;;
        use)   echo "There's nothing you can use right here." ;;
        hug)   echo "After hugging that cat you aren't sure you should try to hug yourself again." ;;
        look)
            echo "A small corridor. Glows emanate from rooms to the east and west."
            echo "A big, old-looking door stands to the south."
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
