#!/bin/bash
clear

# Source the dialogue helper for NPC state management
source ./dialogue_helper.sh

# Initialise the Title Art
file1="../art/titleart.ben"
while IFS= read -r line
do
    echo "$line"
done <"$file1"
echo

# This room now contains an interactive Grue NPC.
# The Grue's dialogue changes based on dialogue state, lever state, and inventory.
grue_state=$(get_dialogue_state "grue")

sleep 1
echo "This is a long, dimly lit room. The walls are lined with bookshelves"
echo "filled with crumbling volumes of poetry. The air smells of old ink."
echo

if [ "$grue_state" = "helped" ]; then
    echo "In the corner, the Grue sits contentedly, humming a tune. It notices"
    echo "you and waves with a warm, toothy smile."
elif [ "$grue_state" = "greeted" ]; then
    echo "The Grue is still here, leafing through a book of verse. It looks up"
    echo "at you hopefully, as if waiting for you to reconsider something."
else
    echo "As you walk down the room, you see a shadowy figure sitting in the"
    echo "corner. Finally! Another person! But as you get closer, your heart"
    echo "sinks. This isn't... no... it can't be. It's... it's..."
    echo "IT'S A GRUE."
    echo
    echo "But this one seems... different. Calmer. It's reading poetry aloud"
    echo "to itself, occasionally chuckling at its own verses."
fi
echo
echo "The exit is to the east, back the way you came."
echo

echo "What would you like to do?"

while true; do
    read -p "> " nsewuh
    case $nsewuh in
        n ) echo "The wall here is covered in framed poetry. You'd rather not get closer." ;;
        s ) echo "A bookshelf blocks the way. The Grue has been busy decorating." ;;
        e ) ./kroo2.sh
            exit ;;
        w ) echo "You try to go deeper into the room, but the Grue's poetry books"
            echo "are stacked so high they form an impassable wall." ;;
        t )
            # === NPC DIALOGUE: THE GRUE ===
            grue_state=$(get_dialogue_state "grue")

            if [ "$grue_state" = "helped" ]; then
                # --- Post-quest: friendly flavor + reminder ---
                echo
                echo "The Grue looks up and grins."
                echo
                echo '  "Ah, my friend! Good to see you again."'
                echo
                leverstate=$(get_lever_state)
                if [ "$leverstate" = "on" ]; then
                    echo '  "I see you have been busy — I can hear the humming from here."'
                fi
                if has_item "grue_amulet"; then
                    echo '  "Keep that amulet close. At the dinner table, remember:'
                    echo '   do NOT swallow the pill. Use it — and the amulet will glow."'
                else
                    echo '  "Strange... you seem to have lost the amulet I gave you."'
                    echo '   Be careful at the dinner table."'
                fi
                echo
                echo '  "Now go. Your adventure is almost over. I believe in you!"'
                echo
            else
                # --- First meeting or greeted: dialogue tree ---
                if [ "$grue_state" = "unmet" ]; then
                    echo
                    echo "You cautiously approach the Grue. It looks up from its book."
                    echo
                    echo '  "Oh! A visitor! How delightful. I am Gwendolyn the Grue,'
                    echo '   poet laureate of the Underground. Would you like to hear'
                    echo '   one of my verses?"'
                else
                    echo
                    echo "The Grue looks up hopefully."
                    echo
                    echo '  "You came back! I knew you would. So... shall we try again?'
                    echo '   Would you like to hear my poetry this time?"'
                fi
                echo
                echo "  1) \"That sounds... interesting. Please, go ahead.\""
                echo "  2) \"Your poetry is terrible. Everyone says so.\""
                echo "  3) \"Maybe another time. Goodbye.\""
                echo
                while true; do
                    read -p "> " reply
                    case $reply in
                        1 )
                            echo
                            echo "The Grue's eyes light up. It clears its throat dramatically."
                            echo
                            echo '  "In darkness deep, where shadows creep,'
                            echo '   The brave adventurer finds secrets to keep.'
                            echo '   The dinner awaits, a pill on the plate —'
                            echo '   But use it, don\'t eat it, to alter your fate."'
                            echo
                            echo "The Grue bows. It's... actually not bad."
                            echo
                            echo '  "Thank you for listening! Most people just run away."'
                            echo '   Please, take this as a token of my gratitude..."'
                            echo
                            echo "The Grue hands you a small, glowing amulet."
                            echo
                            sleep 1
                            give_item "grue_amulet"
                            echo "[You received: Grue Amulet]"
                            echo
                            set_dialogue_state "grue" "helped"
                            echo '  "Remember my verse — at the dinner, use the pill, don\'t swallow it."'
                            echo '   The amulet will do the rest. Now go!"'
                            echo
                            break
                            ;;
                        2 )
                            echo
                            echo "The Grue's face twists with rage. The room grows cold."
                            echo
                            echo '  "HOW DARE YOU! My poetry is ART! You take that back!"'
                            echo
                            echo "You refuse. The Grue stands up. It's much taller than you expected."
                            echo
                            echo '  "Then hear my FINAL verse, insolent worm..."'
                            echo
                            sleep 2
                            echo "The Grue begins to recite. The words burn. Your ears ring."
                            echo "Your vision blurs. Your nose starts to bleed."
                            echo
                            sleep 3
                            echo "You fall to your knees. The poetry... it's inside your head..."
                            echo "tearing through your thoughts like a hurricane of bad metaphors..."
                            echo
                            sleep 3
                            echo "You collapse to the floor, surrounded by your own blood and"
                            echo "the scattered pages of terrible verse."
                            echo
                            echo "YOU ARE DEAD."
                            echo
                            read -p "Press [ENTER] to try again..."
                            ./mainroom.sh
                            exit
                            ;;
                        3 )
                            echo
                            echo '  "Oh... well. Perhaps another time, then."'
                            echo
                            echo "The Grue looks disappointed but returns to its book."
                            echo
                            set_dialogue_state "grue" "greeted"
                            break
                            ;;
                        * ) echo "Choose 1, 2 or 3." ;;
                    esac
                done
            fi
            ;;
        u ) echo
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
        h ) echo "You try to hug the Grue. It hisses at you. You decide against it." ;;
        * ) echo "I'm sorry, I don't understand you. Commands are: n, e, s, w, t, u and h.";;
    esac
done

exit
