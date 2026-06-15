#!/bin/bash
#
# maplib.sh - shared helpers for the map / look commands and room metadata.
#
# This file is SOURCED by each interactive room (`. ./maplib.sh`); it is not run
# on its own. Every room sets the following before sourcing or before calling the
# helpers below:
#
#   ROOM_ID    - short, stable id for this location (e.g. "white")
#   ROOM_NAME  - human-friendly name (e.g. "The White Room")
#   EXITS      - space-separated list of "key:dest[:gate]" entries, where
#                  key  = the command that takes you there (n/s/e/w/u/h)
#                  dest = ROOM_ID of the destination
#                  gate = optional lock condition (only "lever" is used today)
#
# Each room also defines a `describe` function holding its narrative text, which
# `look` re-displays without moving the player.

# Where per-player "visited rooms" are recorded. In multi-user mode the whole game
# tree is copied into a per-player UUID directory (and removed on exit), so this
# path is automatically isolated per player. Overridable for testing.
BV_VISITED_FILE="${BV_VISITED_FILE:-../state/visited}"

# Record the current room (ROOM_ID/ROOM_NAME) as visited, once.
bv_record_visit() {
    [ -n "$ROOM_ID" ] || return 0
    mkdir -p "$(dirname "$BV_VISITED_FILE")" 2>/dev/null
    if ! grep -q "^${ROOM_ID} " "$BV_VISITED_FILE" 2>/dev/null; then
        printf '%s %s\n' "$ROOM_ID" "$ROOM_NAME" >> "$BV_VISITED_FILE"
    fi
}

# Echo the current lever state ("on"/"off"), stripped of surrounding whitespace.
bv_lever_state() {
    cat ../logic/leverlogic.ben 2>/dev/null | tr -d '[:space:]'
}

# Return success (0) if the named gate is currently open / passable.
bv_gate_open() {
    case "$1" in
        lever) [ "$(bv_lever_state)" = "on" ] ;;
        *)     return 0 ;;
    esac
}

# Echo the stored ROOM_NAME for a given ROOM_ID if it has been visited, else nothing.
bv_room_name_for() {
    local target="$1" id rest
    [ -f "$BV_VISITED_FILE" ] || return 0
    while read -r id rest; do
        if [ "$id" = "$target" ]; then
            printf '%s' "$rest"
            return 0
        fi
    done < "$BV_VISITED_FILE"
}

# Map a command key to a readable direction word.
bv_dir_word() {
    case "$1" in
        n) printf 'north' ;;
        s) printf 'south' ;;
        e) printf 'east'  ;;
        w) printf 'west'  ;;
        u) printf 'use'   ;;
        h) printf 'hug'   ;;
        *) printf '%s' "$1" ;;
    esac
}

# Re-display the current room's description without moving.
bv_show_look() {
    if declare -f describe >/dev/null 2>&1; then
        describe
    else
        echo "You look around, but there's nothing more to see."
    fi
}

# Render the map: current location, visited rooms, and exits (with locked/unknown hints).
bv_show_map() {
    local id rest entry key dest gate name word
    echo
    echo "================ MAP ================"
    echo "You are here: ${ROOM_NAME} [${ROOM_ID}]"
    echo
    echo "Rooms you have visited:"
    if [ -s "$BV_VISITED_FILE" ]; then
        while read -r id rest; do
            echo "  - ${rest} [${id}]"
        done < "$BV_VISITED_FILE"
    else
        echo "  (none recorded yet)"
    fi
    echo
    echo "Exits from here:"
    if [ -z "$EXITS" ]; then
        echo "  (no obvious exits)"
    else
        for entry in $EXITS; do
            IFS=: read -r key dest gate <<< "$entry"
            word=$(bv_dir_word "$key")
            if [ -n "$gate" ] && ! bv_gate_open "$gate"; then
                echo "  ${key} (${word}) -> ??? [locked]"
            else
                name=$(bv_room_name_for "$dest")
                if [ -n "$name" ]; then
                    echo "  ${key} (${word}) -> ${name}"
                else
                    echo "  ${key} (${word}) -> ??? (unexplored)"
                fi
            fi
        done
    fi
    echo "===================================="
    echo
}
