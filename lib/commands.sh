#!/bin/bash

# lib/commands.sh - Shared command parsing and help system for BashVenture.
#
# Each room sources this file, declares what it offers via "avail", then runs
# its input loop like so:
#
#     source ../lib/commands.sh
#     avail="go north (n); use (u) or hug (h)"   # describe THIS room's options
#     while true; do
#         read -p "> " input
#         case "$(cmd_normalize "$input")" in
#             n )         ... ;;
#             s )         ... ;;
#             e )         ... ;;
#             w )         ... ;;
#             u )         ... ;;
#             h )         ... ;;
#             look )      cmd_look "$avail" ;;
#             inventory ) cmd_inventory ;;
#             help )      cmd_help "$avail" ;;
#             quit )      cmd_quit ;;
#             * )         cmd_unknown "$avail" ;;
#         esac
#     done
#
# Supported verbs and their aliases:
#   north/n  south/s  east/e  west/w  use/u  hug/h
#   look/l   inventory/i       help/?           quit/q
#
# cmd_normalize keeps the movement verbs as their original single letters
# (n/s/e/w/u/h) so existing room logic does not have to change. The extra
# verbs resolve to whole words (look, inventory, help, quit) and anything
# unrecognised becomes "unknown".

# Turn whatever the player typed into a single canonical token.
# Trims surrounding whitespace and ignores case, so "  North ", "n" and
# "NORTH" all resolve to "n".
cmd_normalize() {
    local s="$1"
    # Strip leading and trailing whitespace (pure bash, no subshell needed).
    s="${s#"${s%%[![:space:]]*}"}"
    s="${s%"${s##*[![:space:]]}"}"
    # Lower-case for case-insensitive matching.
    s="${s,,}"
    case "$s" in
        n|north )     echo "n" ;;
        s|south )     echo "s" ;;
        e|east )      echo "e" ;;
        w|west )      echo "w" ;;
        u|use )       echo "u" ;;
        h|hug )       echo "h" ;;
        l|look )      echo "look" ;;
        i|inventory ) echo "inventory" ;;
        '?'|help )    echo "help" ;;
        q|quit )      echo "quit" ;;
        * )           echo "unknown" ;;
    esac
}

# Print the full command reference, then (optionally) what THIS room offers.
# Usage: cmd_help "$avail"
cmd_help() {
    echo
    echo "Commands you can use anywhere:"
    echo "  north/n  south/s  east/e  west/w  - move around"
    echo "  use/u                             - use whatever is here"
    echo "  hug/h                             - hug whatever is here"
    echo "  look/l                            - look around again"
    echo "  inventory/i                       - check what you're carrying"
    echo "  help/?                            - show this list"
    echo "  quit/q                            - leave the game"
    if [ -n "$1" ]; then
        echo
        echo "Right now you can: $1"
    fi
    echo
}

# Re-describe the player's options without replaying the whole room intro.
# Usage: cmd_look "$avail"
cmd_look() {
    echo "You take a good look around."
    if [ -n "$1" ]; then
        echo "From here you can: $1"
    fi
}

# The game has no real inventory; this keeps the verb meaningful and on-theme.
cmd_inventory() {
    echo "You pat yourself down. All you have is your trusty pillow."
}

# Friendly fallback that tells the player what this room actually accepts.
# Usage: cmd_unknown "$avail"
cmd_unknown() {
    if [ -n "$1" ]; then
        echo "I'm sorry, I don't understand you. Right now you can: $1"
        echo "(Type 'help' or '?' for the full list of commands.)"
    else
        echo "I'm sorry, I don't understand you. Type 'help' or '?' for commands."
    fi
}

# Quit with a confirmation so a stray 'q' does not end the game by accident.
cmd_quit() {
    read -p "Are you sure you want to quit? (y/n) " answer
    case "${answer,,}" in
        y|yes ) echo "Thanks for playing BashVenture!"; exit 0 ;;
        * )     echo "You decide to keep going." ;;
    esac
}
