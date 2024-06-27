#!/bin/bash

# Function to set a primary theme
set_primary_theme() {
    tmux set-option -g status-bg black
    tmux set-option -g status-fg white
    tmux set-option -g pane-border-bg black
    tmux set-option -g pane-border-fg white
    tmux set-option -g pane-active-border-bg black
    tmux set-option -g pane-active-border-fg cyan
    tmux set-option -g message-bg black
    tmux set-option -g message-fg white
}

if [ "$1" == "primary" ]; then
    set_primary_theme
else
    echo "Usage: theme-manager.tmux [primary|....]"
fi
