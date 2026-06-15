#!/bin/bash
# lib/commands.sh — BashVenture shared command parsing library
#
# Provides:
#   parse_command <raw_input>   — normalize + resolve alias → canonical name
#   cmd_available               — print available commands for current room
#   show_help                   — print help listing
#   cmd_loop                    — main input→dispatch loop
#
# Rooms must define:
#   handle_cmd <canonical_command>   — execute the action for a command
#   ROOM_COMMANDS (optional)         — human-readable list for help display

# ---------------------------------------------------------------------------
# parse_command: lowercase, trim whitespace, map aliases to canonical names
# Returns canonical name via stdout.  Rooms match against these names only.
# ---------------------------------------------------------------------------
parse_command() {
    local raw="$1"

    # Trim leading/trailing whitespace
    raw="$(echo "$raw" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

    # Lowercase
    raw="$(echo "$raw" | tr '[:upper:]' '[:lower:]')"

    # Alias → canonical mapping
    case "$raw" in
        north|n)       echo "north" ;;
        south|s)       echo "south" ;;
        east|e)        echo "east"  ;;
        west|w)        echo "west"  ;;
        use|u)         echo "use"   ;;
        hug|h)         echo "hug"   ;;
        look|l)        echo "look"  ;;
        inventory|i)   echo "inventory" ;;
        help|\?)       echo "help"  ;;
        quit|q)        echo "quit"  ;;
        *)             echo "$raw"  ;;   # pass through unknown
    esac
}

# ---------------------------------------------------------------------------
# cmd_available: print the list of commands the player can try right now.
# Uses ROOM_COMMANDS if set; otherwise shows a sensible default.
# ---------------------------------------------------------------------------
cmd_available() {
    if [ -n "$ROOM_COMMANDS" ]; then
        echo "$ROOM_COMMANDS"
    else
        echo "north (n), south (s), east (e), west (w), use (u), hug (h), look (l), inventory (i), help (?), quit (q)"
    fi
}

# ---------------------------------------------------------------------------
# show_help: display the help listing
# ---------------------------------------------------------------------------
show_help() {
    echo "Available commands:"
    echo "  north / n   — move north"
    echo "  south / s   — move south"
    echo "  east  / e   — move east"
    echo "  west  / w   — move west"
    echo "  use   / u   — use something in the room"
    echo "  hug   / h   — hug something (or yourself)"
    echo "  look  / l   — look around the room"
    echo "  inventory / i — check your inventory"
    echo "  help  / ?   — show this help message"
    echo "  quit  / q   — quit the game"
    echo
    echo "Tip: you can type the long or short form of any command."
}

# ---------------------------------------------------------------------------
# cmd_loop: read-eval loop.  Reads one line at a time, parses it, and
# dispatches to handle_cmd (which each room must define before calling this).
# ---------------------------------------------------------------------------
cmd_loop() {
    while true; do
        read -r -p "> " input
        local cmd
        cmd="$(parse_command "$input")"

        case "$cmd" in
            help)
                show_help
                ;;
            quit)
                echo "Thanks for playing BashVenture! Goodbye."
                exit 0
                ;;
            *)
                handle_cmd "$cmd"
                ;;
        esac
    done
}
