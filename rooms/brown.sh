#!/bin/bash
clear
# Initialise the Title Art
file1="../art/titleart.ben"
while IFS= read -r line
do
	echo "$line"
done <"$file1"
echo
sleep 1

# Here's this room's script.

echo "You run south and through an open archway into a dark, dingy place."
echo "The carpet looks like the 70s threw up on it, and the place smells faintly"
echo "of cabbage. This could well be every retirement home ever made, combined"
echo "into one place. It's tragic."
echo
echo "Oddly, though, there's a lever set into the right hand wall."

# Here we tell the player whether the lever is on or off.
leverstate=`cat ../logic/leverlogic.ben`
            if [ "$leverstate" = "on" ]; then
                echo "The last time you were in this room, you turned the lever on. It's still on."
            else
                echo "It looks like it's in the off position."
            fi
echo
echo "The only exit is north, back the way you came."
echo
echo "What would you like to do?"

# Source the shared command library
source ../lib/commands.sh

# Room-specific command handler
# Note: the 'use' command toggles the lever — this is the key game logic switch.
handle_cmd() {
    case "$1" in
        north) ./mainroom.sh; exit ;;
        south) echo "You attempt to walk through the wall. You fail." ;;
        east)  echo "Right, let me explain this whole 'wall' thing to you..." ;;
        west)  echo "Seriously? Though the wall? Sorry, I can't do that." ;;
        use)
            leverstate=`cat ../logic/leverlogic.ben`
            if [ "$leverstate" = "on" ]; then
                echo "Having already turned it on, you try to turn it off. And fail."
            else
                sed -i='' 's/off/on/' ../logic/leverlogic.ben
                echo "You push the lever to 'on', and hear a humming start elsewhere in the building."
            fi
            ;;
        hug)   echo "You hug yourself, and hope nobody is watching." ;;
        look)
            echo "A dingy room that smells of cabbage. There is a lever on the wall."
            echo "The only exit is north."
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
