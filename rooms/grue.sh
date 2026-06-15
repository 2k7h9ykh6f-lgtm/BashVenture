#!/bin/bash
clear

# Pull in the reusable dialogue helpers. Sourcing only defines functions and
# sets DIALOGUE_STATE - it prints nothing - so it is safe here.
source ./dialogue.sh

# Initialise the Title Art
file1="../art/titleart.ben"
while IFS= read -r line
do
    echo "$line"
done <"$file1"
echo

# This room used to be an instant death. Now there is a fellow captive you can
# actually talk to, and talking your way through is the only way back out.
sleep 1
echo "This is a long room, and as you walk down it, you see a figure."
echo "Finally! Another person! You start to run toward the shadowy shape"
echo "but then stop dead. This isn't... no... it can't be. It's... it's..."
echo "IT'S A GRUE."
sleep 2
echo
echo "Mercifully, the great brute is slumped against the far wall, snoring,"
echo "a battered book of its dreaded Grue Poetry open across its lap."
sleep 2
echo
echo "Pressed into the shadows beside you, a trembling fellow captive catches"
echo "your eye and frantically waves you over, one finger pressed to their lips."
echo
echo "What would you like to do? (try 'talk' to speak with them)"

while true; do
    read -p "> " nsewuh
    case $nsewuh in
        talk | t )
            met=$(dialogue_get grue_npc_met)
            leverstate=$(state_read ../logic/leverlogic.ben)

            # Greeting depends on whether the player has met this NPC before.
            if [ "$met" != "yes" ]; then
                echo
                echo "You creep over. 'Thank GOODNESS,' they breathe. 'I'm a captive,"
                echo "same as you. That thing recites poetry until your brain leaks out"
                echo "of your ears. Whatever you do - do NOT wake it.'"
                dialogue_set grue_npc_met yes
            else
                echo
                echo "'You again,' the captive whispers. 'Still in one piece. Good."
                echo "Keep your voice DOWN.'"
            fi

            # Extra line flavoured by what the player carries / has done.
            if dialogue_has_item lantern; then
                echo
                echo "They glance at the brass lantern in your hands and relax a little."
                echo "'The light. Yes. The grue can't abide it - you're as safe as anyone"
                echo "gets in here.'"
            elif [ "$leverstate" = "on" ]; then
                echo
                echo "A low humming drifts in from somewhere deep in the building. The"
                echo "captive's eyes go wide. 'You hear that? YOU did that, didn't you?"
                echo "The grue loathes that sound - look, it's twitching in its sleep.'"
            fi

            echo
            echo "'Quick,' they whisper, 'how do we play this?'"
            echo "  [1] Shout at the grue and demand it set you both free"
            echo "  [2] Ask the captive, quietly, how to survive this place"
            echo "  [3] Say nothing - back away and slip out the way you came"
            read -p "  choose 1-3 > " choice
            case $choice in
                1 )
                    echo
                    echo "You fill your lungs and bellow at the grue. Bad idea."
                    sleep 2
                    echo "Its eyes snap open. 'AH - AN AUDIENCE!' it rumbles, delighted,"
                    echo "and sits you down to read its Grue Poetry. It is awful. Your"
                    echo "brain begins to melt; your nose starts to bleed."
                    sleep 3
                    echo
                    echo "You slip into unconsciousness."
                    sleep 2
                    echo "YOU ARE DEAD."
                    echo
                    read -p "Press [ENTER] to try again..."
                    ./mainroom.sh
                    exit ;;
                2 )
                    if dialogue_has_item lantern; then
                        echo
                        echo "'You already have the lantern,' they whisper, almost smiling."
                        echo "'Then stop dawdling and GO - the light is all the protection"
                        echo "you need. Slip out while it sleeps.'  (choose 3 to leave)"
                    elif [ "$leverstate" = "on" ]; then
                        dialogue_give_item lantern
                        echo
                        echo "'That hum is your chance.' They press a small brass lantern"
                        echo "into your hands. 'I kept it hidden. Light it and the grue"
                        echo "won't come near you. Take it - GO.'"
                        echo
                        echo "  >> You got the LANTERN! <<"
                    else
                        echo
                        echo "'Listen carefully,' they breathe. 'Somewhere in this building"
                        echo "is a lever. Throw it. It starts a humming the grue cannot bear -"
                        echo "and while the brute is distracted, I can get you what you need."
                        echo "Find that lever, then come back to me.'"
                        echo
                        echo "  >> HINT: find a lever elsewhere, switch it on, then return. <<"
                    fi
                    ;;
                3 )
                    echo
                    echo "You give the captive a tiny nod, hold your breath, and edge back"
                    echo "past the snoring grue and out of the room."
                    echo
                    read -p "Press [ENTER] to continue..."
                    ./mainroom.sh
                    exit ;;
                * )
                    echo "  The captive frowns. 'That's not one of your options. Focus!'" ;;
            esac
            ;;
        n ) echo "The grue is slumped against the wall that way. Best not get closer." ;;
        s ) echo "Just cold, damp stone wall to the south." ;;
        e ) echo "The way you came in. You could leave - but maybe talk first." ;;
        w ) echo "A wall. And beyond it, presumably, more grues. Hard pass." ;;
        u ) echo "Nothing here worth using - and rummaging might wake the grue." ;;
        h ) echo "You badly want a hug. The only candidate is a sleeping grue. No." ;;
        * ) echo "I'm sorry, I don't understand you. Commands are: talk, n, e, s, w, u and h." ;;
    esac
done

exit
