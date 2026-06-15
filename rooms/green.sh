#!/bin/bash
clear
# Initialise the Title Art
file1="../art/titleart.ben"
while IFS= read -r line
do
	echo "$line"
done <"$file1"
echo

# Everybody clap your hands. I mean, here is the script.
sleep 1
echo "You're off to see the wizard. Well, maybe not - but this"
echo "room is so green you might as well be in Emerald City."
echo "Seriously. Think of the greenest thing you've ever seen,"
echo "then add another suitcase full of green. It's that bad."
echo
echo "It's getting to you. Such pain. Is there a door? Who knows."
echo
echo "What would you like to do?"

# Source the shared command library
source ../lib/commands.sh

# Room-specific command handler
handle_cmd() {
    case "$1" in
        north) echo "The green is a bit more intense over here. Oops." ;;
        south) echo "Such green. Much bad. Go back. SCHTAP." ;;
        east)  ./mainroom.sh; exit ;;
        west)  echo "You attempt to go west, but ALL YOU SEE IS GREEN." ;;
        use)   echo "You think about 'using' green, but realise it's not legal in this country." ;;
        hug)   echo "You curl yourself up into a ball and rock back and forth." ;;
        look)
            echo "An intensely green room. The only exit you can see is to the east."
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
