#!/bin/bash
clear

# Logic in the game is stored in .ben files. This sample has just one 'logic' file.
# You can add more logic files by simply adding a 'sed' command and appropriate .ben file.
# First off, let us reset the game logic. Use this as an example.

sed -i='' 's/on/off/' ../logic/leverlogic.ben

# Who doen't love ASCII text, right?
# Next up, let's initialise the Title Art
file1="../art/titleart.ben"
while IFS= read -r line
do
	echo "$line"
done <"$file1"
echo

# Next up, let's load in the initial introduction. Script is also stored in .ben files.
sleep 5
file2="../script/opening.ben"
while IFS= read -r line
do
	echo "$line"
done <"$file2"
read -p "Press [ENTER] to start..."

#Okay, now that the introduction is out of the way, we can start the first room!
clear
file1="../art/titleart.ben"
while IFS= read -r line
do
	echo "$line"
done <"$file1"
sleep 1

# Here's where you introduce the room to the player. Be sure to tell them if there
# Are exits - but don't give too much away. Make it fun for them to explore!
echo
echo "You awake to find yourself on the floor of a large room."
echo "You still have your pillow, but your bed and duvet are gone."
echo "You stand up, dazed and confused. It's a Thursday, or - at"
echo "least - you think it is. You never could quite get the hang"
echo "of Thursdays."
echo
echo "You can just about see doors to the north, east, south and west."
echo "It's kinda cold, and you're hungry."
echo
echo "What would you like to do?"

# Source the shared command library
source ../lib/commands.sh

# Room-specific command handler
handle_cmd() {
    case "$1" in
        north) ./white.sh; exit ;;
        south) ./brown.sh; exit ;;
        east)  ./red.sh; exit ;;
        west)  ./green.sh; exit ;;
        use)   echo "There's nothing you can use right here." ;;
        hug)   echo "You give yourself a quick hug. It's not very satisfying." ;;
        look)
            echo "You are in a large room. Doors lead north, east, south and west."
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
