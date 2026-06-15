#!/bin/bash
clear
# Initialise the Title Art
file1="../art/titleart.ben"
while IFS= read -r line
do
	echo "$line"
done <"$file1"
echo

#Setting up the room...
sleep 1
echo "You're in a room that has an odd red glow to it."
echo "Bookcases line the walls - dusty volumes with titles you"
echo "can't quite make out. Somehow they seem ancient."
echo
echo "There's a very comfortable looking chair in the corner."
echo "The only exit is to the west, back in the direction you came."
echo
echo "What would you like to do?"

# Source the shared command library
source ../lib/commands.sh

# Room-specific command handler
handle_cmd() {
    case "$1" in
        north) echo "Face, meet wall. Wall, meet Face." ;;
        south) echo "You can't walk through walls." ;;
        east)  echo "Nothing but wall here." ;;
        west)  ./mainroom.sh; exit ;;
        use)   echo "You sit in the comfortable chair. It's like sitting on a cloud." ;;
        hug)   echo "You give yourself a hug, hoping that the books won't judge you." ;;
        look)
            echo "A room with an odd red glow, dusty bookcases, and a comfortable chair."
            echo "The only exit is to the west."
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
