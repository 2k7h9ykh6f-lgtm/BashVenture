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

# And here's what you could have won... 
while true; do
    read -p "> " nsewuh
    case $nsewuh in
        n ) echo "The green is a bit more intense over here. Oops." ;;
        s ) echo "Such green. Much bad. Go back. SCHTAP." ;;
        e ) ./mainroom.sh
            exit ;;
        w ) echo "You attempt to go west, but ALL YOU SEE IS GREEN." ;;
		u ) echo "You think about 'using' green, but realise it's not legal in this country." ;;
		h ) echo "You curl yourself up into a ball and rock back and forth." ;;
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