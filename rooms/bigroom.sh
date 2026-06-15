#!/bin/bash
clear
# Initialise the Title Art
file1="../art/titleart.ben"
while IFS= read -r line
do
    echo "$line"
done <"$file1"

# This is close to the endgame, but affords the player a last set of things to try and do.
# Obviously if you use this framework to create a game of your own, you can extend this massively.
echo
sleep 1
echo "You step through the door and into what looks like a scene from a movie."
echo
sleep 3
echo "There's a long table in front of you. Sat around it are several well-dressed"
echo "people, both men and women, eating a very elaborate looking dinner."
sleep 2
echo "Weird."
echo
sleep 3
echo "There appears to have been a place laid at the table for you."
echo
sleep 5
echo "Suddenly nervous, you take a seat and look around at the other diners."
echo "Are these the people who summoned you here? You try to ask them, but"
echo "seem to be rendered more speechless than a test subject in a portal game."
echo
sleep 5
echo
echo "A waiter brings out a tray and places it in front of you. Lifting the lid,"
echo "you find a weird rainbow coloured pill in front of you. Very 'Martix', you think"
echo "to yourself. What does this mean? Are you supposed to take the pill?"
echo "Is this some kind of test? And who ARE these people?!"
echo
sleep 5
echo
echo "What would you like to do?"

# Source the shared command library
source ../lib/commands.sh

# Room-specific command handler
handle_cmd() {
    case "$1" in
        north) echo "You get up and look around. Not much over here." ;;
        south) echo "You take a look at the decor of the room. It's pretty nice." ;;
        east)  echo "There's a curtain - but no window behind it. How odd." ;;
        west)  echo "WHO ARE THESE PEOPLE?!" ;;
        use)   ./end.sh; exit ;;
        hug)   echo "You hug the person next to you. He feels cold, and doesn't move." ;;
        look)
            echo "An elaborate dinner scene with well-dressed guests and a rainbow pill on your plate."
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
