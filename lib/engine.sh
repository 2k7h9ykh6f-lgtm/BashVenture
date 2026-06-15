#!/bin/bash
# lib/engine.sh - BashVenture Map and Look Engine
# Source this file at the top of each room script:
#   source ../lib/engine.sh
#
# Each room must define:
#   ROOM_ID    - unique string identifier (e.g., "mainroom")
#   ROOM_NAME  - human-readable name (e.g., "Large Room")
#   EXITS      - space-separated "direction:destination" pairs
#                (e.g., "n:white s:brown e:red w:green")
#   EXITS_LOCKED - (optional) space-separated locked/conditional exits
#                  Format: "action>dest:condition" or "dir:dest:condition"
#                  Conditions: lever_on, always

# --- Visited File Path ---
# Relative to room scripts (which run from inside rooms/)
VISITED_FILE="../logic/.visited"

# --- init_game <starting_room_id> ---
# Called ONCE from start.sh to begin a fresh game.
# Clears the visited file and marks the starting room.
init_game() {
    local starting_room="$1"
    > "$VISITED_FILE"
    mark_visited "$starting_room"
}

# --- init_room ---
# Called at the top of each room script (after setting ROOM_ID).
# Marks the current room as visited.
init_room() {
    mark_visited "$ROOM_ID"
}

# --- mark_visited <room_id> ---
# Appends room_id to the visited file if not already present.
mark_visited() {
    local room_id="$1"
    if [ ! -f "$VISITED_FILE" ]; then
        echo "$room_id" > "$VISITED_FILE"
        return
    fi
    if ! grep -qx "$room_id" "$VISITED_FILE" 2>/dev/null; then
        echo "$room_id" >> "$VISITED_FILE"
    fi
}

# --- is_visited <room_id> ---
# Returns 0 (true) if the room has been visited, 1 otherwise.
is_visited() {
    grep -qx "$1" "$VISITED_FILE" 2>/dev/null
}

# --- get_room_name <room_id> ---
# Lookup table: returns the human-readable name for a room ID.
get_room_name() {
    case "$1" in
        mainroom)  echo "Large Room" ;;
        white)     echo "White Room" ;;
        brown)     echo "Brown Room" ;;
        red)       echo "Red Room" ;;
        green)     echo "Green Room" ;;
        kroo)      echo "Corridor" ;;
        kroo2)     echo "Small Corridor" ;;
        bigroom)   echo "Gaming Den" ;;
        gameroom)  echo "Dinner Hall" ;;
        grue)      echo "Long Room" ;;
        end)       echo "???" ;;
        *)         echo "Unknown" ;;
    esac
}

# --- _dot_pad <label_length> <status_length> ---
# Internal: generates a dot string to fill the space between
# the room name and the status word, targeting a 44-char line.
_dot_pad() {
    local label_len="$1"
    local status_len="$2"
    # Layout: "    [X] " (8) + label + " " + dots + " " + status
    # Target total: 44 chars
    local used=$(( 8 + label_len + 1 + 1 + status_len ))
    local dots_needed=$(( 44 - used ))
    if [ "$dots_needed" -lt 3 ]; then
        dots_needed=3
    fi
    local long_dots="........................................"
    echo "${long_dots:0:$dots_needed}"
}

# --- _check_condition <condition> ---
# Internal: evaluates a lock condition. Returns 0 if UNLOCKED,
# 1 if still locked.
_check_condition() {
    local condition="$1"
    case "$condition" in
        lever_on)
            local leverstate
            leverstate=$(cat ../logic/leverlogic.ben 2>/dev/null)
            [ "$leverstate" = "on" ] && return 0
            return 1
            ;;
        always)
            return 1
            ;;
        *)
            return 1
            ;;
    esac
}

# --- show_map ---
# Renders the map display. Requires ROOM_ID, ROOM_NAME, EXITS,
# and optionally EXITS_LOCKED to be set.
show_map() {
    echo
    echo "==================== MAP ===================="
    echo "  Location: * $ROOM_NAME ($ROOM_ID)"
    echo

    local has_locked_section=false

    # -- Normal exits --
    if [ -n "$EXITS" ]; then
        echo "  Exits:"
        local exit_entry dir dest dir_upper dest_name status dots
        for exit_entry in $EXITS; do
            dir="${exit_entry%%:*}"
            dest="${exit_entry##*:}"
            dir_upper=$(echo "$dir" | tr '[:lower:]' '[:upper:]')
            dest_name=$(get_room_name "$dest")

            status="unknown"
            if is_visited "$dest"; then
                status="visited"
            fi

            dots=$(_dot_pad ${#dest_name} ${#status})
            echo "    [$dir_upper] $dest_name $dots $status"
        done
    fi

    # -- Locked / conditional exits --
    if [ -n "$EXITS_LOCKED" ]; then
        local showed_header=false
        local locked_entry condition action_dest action dest action_upper dest_name status label dots
        for locked_entry in $EXITS_LOCKED; do
            # Extract condition (last field after :)
            condition="${locked_entry##*:}"
            # Everything before the condition
            action_dest="${locked_entry%:*}"

            # Check if there is a > (special action like hug)
            if [[ "$action_dest" == *">"* ]]; then
                action="${action_dest%%>*}"
                dest="${action_dest##*>}"
            else
                # Standard direction: locked exit (format: dir:dest:condition)
                # action_dest is "dir:dest", we need to split it
                action="${action_dest%%:*}"
                dest="${action_dest#*:}"
            fi

            action_upper=$(echo "$action" | tr '[:lower:]' '[:upper:]')

            if _check_condition "$condition"; then
                # Unlocked: show destination
                dest_name=$(get_room_name "$dest")
                status="unknown"
                if is_visited "$dest"; then
                    status="visited"
                fi
                if ! $showed_header; then
                    echo
                    echo "  Unlocked:"
                    showed_header=true
                fi
                dots=$(_dot_pad ${#dest_name} ${#status})
                echo "    [$action_upper] $dest_name $dots $status"
            else
                # Still locked
                status="locked"
                label="???"
                if ! $showed_header; then
                    echo
                    echo "  Locked:"
                    showed_header=true
                fi
                dots=$(_dot_pad ${#label} ${#status})
                echo "    [$action_upper] $label $dots $status"
                has_locked_section=true
            fi
        done
    fi

    # -- No exits at all --
    if [ -z "$EXITS" ] && [ -z "$EXITS_LOCKED" ]; then
        echo "  No visible exits."
    fi

    echo "=============================================="
    echo
}
