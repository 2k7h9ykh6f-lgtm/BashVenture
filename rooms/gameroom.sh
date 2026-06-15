#!/bin/bash
clear
# Initialise the Title Art
file1="../art/titleart.ben"
while IFS= read -r line
do
    echo "$line"
done <"$file1"
echo

# This room gives the player a typical poisoned apple style scenaro.
# Just because something looks shiny and fun, doesn't make it any
# less deadly.
sleep 1
echo "This room is small, but has a pretty sweet looking computer"
echo "sat on a desk in the middle of it. Is that... YES!"
echo "Steam is installed, and it looks like the entire library of"
echo "games is installed! This is one epic gaming rig."
echo
echo "The only way out is east, back the way you came... but..."
echo "shiny. Maybe it'd be rude NOT to sit down and game a little."
echo
echo "What would you like to do?"

# Source the shared command library
source ../lib/commands.sh

# Room-specific command handler
handle_cmd() {
    case "$1" in
        north) echo "WALL EQUALS TRUE." ;;
        south) echo "Nope. Wall." ;;
        west)  ./kroo2.sh; exit ;;
        east)  echo "You were going to go east, then you took a wall to the face." ;;
        use)
            echo
            echo "You sit and game. And game. And game. You forget about time,"
            echo "and food, and people. You realise that you cannot get up. You can't"
            echo "move. You are stuck to the chair."
            echo
            sleep 4
            echo "Days go by. Weeks. You've played game after game, but..."
            echo
            echo "Your body is giving up. With your final breath you come to realise that"
            echo "you cannot live on gamerpoints alone. You close your eyes for the last time."
            sleep 4
            echo
            echo
            echo "YOU ARE DEAD."
            echo
            read -p "Press [ENTER] to try again..."
            ./mainroom.sh
            exit
            ;;
        hug)   echo "You hug the computer. Nerd." ;;
        look)
            echo "A small room with an epic gaming rig. Steam is installed!"
            echo "The only way out is to the west."
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
