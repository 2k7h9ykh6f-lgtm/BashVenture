#!/bin/bash
# dialogue_helper.sh — Reusable NPC dialogue and inventory helpers
# Source this file at the top of any room script:
#   source ./dialogue_helper.sh

# ============================================================
# DIALOGUE STATE
# ============================================================
# Each NPC has a state file: ../logic/dialogue_<npc_id>.ben
# The file contains a single word representing the current state.
# Example states: unmet, greeted, helped, hostile, etc.
# ============================================================

get_dialogue_state() {
    local npc_id="$1"
    local statefile="../logic/dialogue_${npc_id}.ben"
    if [ -f "$statefile" ]; then
        cat "$statefile" | tr -d '[:space:]'
    else
        echo "unmet"
    fi
}

set_dialogue_state() {
    local npc_id="$1"
    local new_state="$2"
    local statefile="../logic/dialogue_${npc_id}.ben"
    echo "$new_state" > "$statefile"
}

# ============================================================
# INVENTORY
# ============================================================
# Items are stored one per line in ../logic/inventory.ben
# Use give_item to add, has_item to check, remove_item to take away.
# ============================================================

INVENTORY_FILE="../logic/inventory.ben"

has_item() {
    local item_id="$1"
    if [ -f "$INVENTORY_FILE" ]; then
        grep -q "^${item_id}$" "$INVENTORY_FILE"
        return $?
    fi
    return 1
}

give_item() {
    local item_id="$1"
    if ! has_item "$item_id"; then
        echo "$item_id" >> "$INVENTORY_FILE"
    fi
}

remove_item() {
    local item_id="$1"
    if [ -f "$INVENTORY_FILE" ]; then
        local tmpfile="${INVENTORY_FILE}.tmp"
        grep -v "^${item_id}$" "$INVENTORY_FILE" > "$tmpfile" 2>/dev/null
        mv "$tmpfile" "$INVENTORY_FILE"
    fi
}

# ============================================================
# LEVER STATE (convenience wrapper)
# ============================================================

get_lever_state() {
    local leverfile="../logic/leverlogic.ben"
    if [ -f "$leverfile" ]; then
        cat "$leverfile" | tr -d '[:space:]'
    else
        echo "off"
    fi
}
