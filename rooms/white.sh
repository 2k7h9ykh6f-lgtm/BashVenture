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
echo "You run north, pushing through the half-open doorway ahead."
echo "The room you find yourself in is bright. A sign on the wall tells"
echo "you that you are in the White Room. I guess that explains why it's"
echo "so bright and all that..."
echo

# Here we're going to check to see if the lever - the only logic we are using in this game - is on or off.
leverstate=`cat ../logic/leverlogic.ben`
            if [ "$leverstate" = "on" ]; then
                echo "There's a delecately carved statue at the end of the room."
                echo "It's a kitten, hewn from beautiful white marble."
                echo "It is also emitting a strange humming noise."
            else
                echo "There's a delecately carved statue at the end of the room."
                echo "It's a kitten, hewn from beautiful white marble."
            fi

echo
echo "The only exit is south, back the way you came."
echo
echo "What would you like to do?"

# Source the shared command library
source ../lib/commands.sh

# Room-specific command handler
# Note: hug action changes depending on whether the lever is on or off.
handle_cmd() {
    case "$1" in
        north) echo "Somehow you think walls don't apply to you. They do." ;;
        south) ./mainroom.sh; exit ;;
        east)  echo "No can do. There's a wall there." ;;
        west)  echo "Seriously? Though the wall? Sorry, I can't do that." ;;
        use)   echo "You try to use the statue. It feels weird, so you stop." ;;
        hug)
            leverstate=`cat ../logic/leverlogic.ben`
            if [ "$leverstate" = "on" ]; then
                ./kroo.sh
                exit
            else
                echo "You hug the statue. It seems to vibrate a little. Weird."
            fi
            ;;
        look)
            echo "A bright white room with a delicately carved marble kitten statue."
            echo "The only exit is south."
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
