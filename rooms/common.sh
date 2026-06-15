#!/bin/bash

# Shared helpers for BashVenture. This file is *sourced* by each room script,
# so the save/load logic lives in exactly one place instead of being copied
# into every room. Rooms only need two extra lines:
#
#     . "$(dirname "$0")/common.sh"          # near the top of the script
#     bv_global "$nsewuh" && continue        # first line inside the input loop
#
# Because it is sourced (not executed), $0 inside these functions is still the
# *room* script that called them - so bv_save can work out which room you are
# in without every room having to hard-code its own name.

# Where the save lives. It deliberately sits in the player's home directory,
# OUTSIDE the throwaway per-player folder that adventure.sh creates and deletes,
# so progress survives between sessions. Overridable for testing.
BV_SAVE_FILE="${BV_SAVE_FILE:-$HOME/.bashventure_save}"

# Game state lives in ../logic relative to the rooms directory (the rooms always
# run with the rooms folder as their working directory).
BV_LOGIC_DIR="../logic"

# bv_save: write the minimal player state to a human-readable save file.
# State that actually matters: which room you are in, the lever logic, and the
# (currently empty) inventory. Returns non-zero if the file could not be written.
bv_save() {
    local room lever inv
    room=$(basename "$0")
    lever=$(cat "$BV_LOGIC_DIR/leverlogic.ben" 2>/dev/null)
    [ -n "$lever" ] || lever="off"
    inv=$(cat "$BV_LOGIC_DIR/inventory.ben" 2>/dev/null)

    {
        echo "# BashVenture save file - edit at your own peril."
        echo "ROOM=$room"
        echo "LEVER=$lever"
        echo "INVENTORY=$inv"
    } > "$BV_SAVE_FILE"
}

# bv_clear_save: remove the save file (used when the game is finished, so a
# completed adventure is not offered up as "continue where you left off").
bv_clear_save() {
    rm -f "$BV_SAVE_FILE"
}

# bv_global: handle the commands that are valid in EVERY room.
#   - returns 0 if it handled the command (the room loop should 'continue')
#   - returns 1 if it did not, so the room's own 'case' can deal with it
# 'quit' saves first, then exits the game cleanly.
bv_global() {
    case "$1" in
        save )
            if bv_save; then
                echo "Game saved. You can quit now and continue later."
            else
                echo "Sorry - I couldn't write your save file."
            fi
            return 0 ;;
        quit | q | exit )
            bv_save
            echo "Game saved. See you next time!"
            exit 0 ;;
        * )
            return 1 ;;
    esac
}
