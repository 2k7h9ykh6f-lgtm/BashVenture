#!/bin/bash

clear

# Logic in the game is stored in .ben files. This sample has just one 'logic' file.
# You can add more logic files by simply adding a 'sed' command and appropriate .ben file.
# First off, let us reset the game logic. Use this as an example.

sed -i='' 's/on/off/' ../logic/leverlogic.ben
> ../logic/inventory.ben

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

# Now we wait for their response - and send them somewhere accordingly.
while true; do
    read -p "> " nsewuh
    case $nsewuh in
        n ) ./white.sh 
            exit ;;       # These lines will take the player to a new room - a new script file.
        s ) ./brown.sh 
            exit ;;       # Be sure to include 'exit' otherwise the game won't quit properly!
        e ) ./red.sh
        	exit ;;
        w ) ./green.sh
        	exit ;;
		u ) echo "There's nothing you can use right here." ;;
		h ) echo "You give yourself a quick hug. It's not very satisfying." ;;
		i|inventory )
			if [ -s ../logic/inventory.ben ]; then
				echo "You check your backpack. You are carrying:"
				while IFS= read -r item; do
					echo "  - $item"
				done <../logic/inventory.ben
			else
				echo "Your backpack is empty."
			fi ;;
        * ) echo "I'm sorry, I don't understand you. Commands are: n, e, s, w, u, h and i.";;
    esac
done

esac
exit