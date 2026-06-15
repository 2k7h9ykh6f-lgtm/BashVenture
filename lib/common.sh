#!/bin/bash
# BashVenture - Common command handler library
# Provides save/load/quit/help functionality shared across all rooms.

SAVE_FILE="$HOME/.bashventure_save"

# Save current game state
# Usage: save_game <room_name>
save_game() {
    local room="$1"
    local lever
    lever=$(cat ../logic/leverlogic.ben 2>/dev/null)
    lever=$(echo "$lever" | tr -d '[:space:]')

    cat > "$SAVE_FILE" <<EOF
# BashVenture Save File
# Saved: $(date '+%Y-%m-%d %H:%M:%S')
room=$room
lever=$lever
EOF

    if [ $? -eq 0 ]; then
        echo "Game saved successfully."
        return 0
    else
        echo "Failed to save game."
        return 1
    fi
}

# Check if a valid save file exists
# Returns 0 if save exists and is valid, 1 otherwise
has_save() {
    if [ -f "$SAVE_FILE" ]; then
        if grep -q "^room=" "$SAVE_FILE" 2>/dev/null; then
            return 0
        fi
    fi
    return 1
}

# Load game state from save file
# Sets SAVED_ROOM variable with the room to load
# Returns 0 on success, 1 on failure
load_game() {
    if ! has_save; then
        echo "No save file found."
        return 1
    fi

    local room lever

    room=$(grep "^room=" "$SAVE_FILE" | cut -d'=' -f2)
    lever=$(grep "^lever=" "$SAVE_FILE" | cut -d'=' -f2)

    if [ -z "$room" ]; then
        echo "Save file is corrupted."
        delete_save
        return 1
    fi

    # Verify the room file exists
    if [ ! -f "$room" ]; then
        echo "Save file references invalid room. Starting new game."
        delete_save
        return 1
    fi

    # Restore lever state
    if [ -n "$lever" ]; then
        echo "$lever" > ../logic/leverlogic.ben
    fi

    SAVED_ROOM="$room"
    return 0
}

# Delete the save file
delete_save() {
    rm -f "$SAVE_FILE" 2>/dev/null
}

# Clean up for a new game (remove any existing save)
new_game_cleanup() {
    delete_save
}

# Handle common commands (save, quit, help)
# Usage: handle_common <command> <room_name>
# Returns 0 if command was handled, 1 if not (for the room's * case)
handle_common() {
    local cmd="$1"
    local room="$2"

    case "$cmd" in
        save )
            save_game "$room"
            return 0
            ;;
        quit|q )
            echo "Thanks for playing BashVenture!"
            exit 0
            ;;
        help )
            echo "Available commands:"
            echo "  n, s, e, w  - Move north, south, east, west"
            echo "  u           - Use an object"
            echo "  h           - Hug something"
            echo "  save        - Save your current progress"
            echo "  quit        - Quit the game"
            echo "  help        - Show this help message"
            return 0
            ;;
        * )
            return 1
            ;;
    esac
}
