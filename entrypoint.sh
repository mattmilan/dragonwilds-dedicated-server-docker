#!/usr/bin/env bash

# The work of entrypoint has been divided among the scripts in entrypoint.d/
# This file simply executes them in alphabetical order. Order is important!
# Arguments will be passed to the last script (in this case the game server)

set -e
shopt -s nocasematch  # Enable case-insensitive matching (Reverted at EOF)

INIT_DIR="/entrypoint.d"

# Function to indent output
indent_output() {
    sed 's/^/    │ /'
}

echo "🚀 Starting container initialization..."

# TODO: require dirs/files? raise error if missing?

if [ -d "$INIT_DIR" ]; then
    for script in "$INIT_DIR"/*.sh; do
        [ -f "$script" ] || continue

        echo "▶ Running init script: $(basename "$script")"

        if [ -x "$script" ]; then
            # Executable → run in subshell, isolate env
            {
                "$script"
            } 2>&1 | indent_output
        else
            # Non-executable → source into current shell, share env
            {
                source "$script"
            } 2>&1 | indent_output
        fi
    done
fi

echo "✅ Initialization complete."

# clean up
shopt -u nocasematch  # Revert case-insensitive matching

# Hand off to main process
exec "$@"
