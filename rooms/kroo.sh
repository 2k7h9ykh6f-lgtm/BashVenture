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
            echo "A small corridor with glows to the east and west, and a big door to the south."
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
