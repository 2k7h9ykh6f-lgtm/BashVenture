#!/bin/bash

# ---------------------------------------------------------------------------
# BashVenture - reusable NPC dialogue / state helper.
#
# This file is meant to be *sourced* by a room script, e.g.:
#
#     source ./dialogue.sh
#
# It defines a tiny key=value store so NPCs can remember what the player has
# done (talked before, picked up an item, etc.). Because adventure.sh copies
# the whole logic/ folder into a per-player UUID directory, the state file is
# automatically private to each player - multiple players never collide.
#
# Sourcing this file has no visible side effects (it only sets DIALOGUE_STATE
# and defines functions) so it is safe to pull into any room.
#
# Public functions:
#   state_read FILE          - print a single-value state file, CR/LF stripped
#   dialogue_get KEY         - print the stored value for KEY (empty if unset)
#   dialogue_set KEY VALUE   - store VALUE under KEY (creates/updates)
#   dialogue_reset           - wipe all dialogue state (used by start.sh)
#   dialogue_has_item ITEM   - succeed (exit 0) if the player owns ITEM
#   dialogue_give_item ITEM  - mark ITEM as owned by the player
# ---------------------------------------------------------------------------

# Where the dialogue state lives. Overridable (handy for tests); defaults to
# the per-player logic folder relative to the rooms/ working directory.
DIALOGUE_STATE="${DIALOGUE_STATE:-../logic/dialogue.ben}"

# Read a one-value state file (like logic/leverlogic.ben) and strip carriage
# returns / newlines. The .ben files ship with CRLF endings, so a naive
# `cat` leaves a trailing \r that breaks string comparisons - this avoids that.
state_read() {
    [ -f "$1" ] || return 0
    tr -d '\r\n' < "$1"
}

# Print the value stored for KEY, or nothing if the key is not present.
dialogue_get() {
    local key="$1" line
    [ -n "$key" ] || return 0
    [ -f "$DIALOGUE_STATE" ] || return 0
    line=$(grep "^${key}=" "$DIALOGUE_STATE" 2>/dev/null | tail -n 1)
    line=${line#*=}
    printf '%s' "$line" | tr -d '\r'
}

# Store VALUE under KEY, replacing any previous value. The file is rewritten
# with clean LF endings so it stays robust across platforms.
dialogue_set() {
    local key="$1" value="$2" tmp
    [ -n "$key" ] || return 1
    tmp="${DIALOGUE_STATE}.tmp.$$"
    if [ -f "$DIALOGUE_STATE" ]; then
        grep -v "^${key}=" "$DIALOGUE_STATE" 2>/dev/null | tr -d '\r' > "$tmp"
    else
        : > "$tmp"
    fi
    printf '%s=%s\n' "$key" "$value" >> "$tmp"
    mv "$tmp" "$DIALOGUE_STATE"
}

# Clear every remembered choice. start.sh calls this so a fresh playthrough
# does not inherit dialogue state from a previous single-user game.
dialogue_reset() {
    : > "$DIALOGUE_STATE"
}

# Inventory helpers, layered on top of the key=value store.
dialogue_has_item() {
    [ "$(dialogue_get "item_$1")" = "yes" ]
}

dialogue_give_item() {
    dialogue_set "item_$1" yes
}
