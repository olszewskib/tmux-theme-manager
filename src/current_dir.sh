#!/bin/sh

# Get the pane ID of the current pane
pane_id=$(tmux display-message -p "#{pane_id}")

# Get the current working directory of the pane
current_dir=$(tmux display-message -p -t "$pane_id" "#{pane_current_path}")

# Display the current working directory
echo "$current_dir" | sed "s|$HOME|~|"

