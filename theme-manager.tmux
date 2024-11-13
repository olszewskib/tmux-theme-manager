#!/usr/bin/env bash

get_tmux_option() {
    local option value default
    option="$1"
    default="$2"
    value="$(tmux show-option -gqv "$option")"

    if [ -n "$value" ]; then
        echo "$value"
    else
        echo "$default"
    fi
}

set() {
    local option=$1
    local value=$2
    tmux_commands+=(set-option -gq "$option" "$value" ";")
}

setw() {
    local option=$1
    local value=$2
    tmux_commands+=(set-window-option -gq "$option" "$value" ";")
}

main() {
    local theme
    theme="$(get_tmux_option "@prime-variant" "main")"

    if [[ $theme == main ]]; then

        thm_base="#191724";
        thm_surface="#1f1d2e";
        thm_overlay="#26233a";
        thm_muted="#6e6a86";
        thm_subtle="#908caa";
        thm_text="#e0def4";
        thm_love="#eb6f92";
        thm_gold="#f6c177";
        thm_rose="#ebbcba";
        thm_pine="#31748f";
        thm_foam="#9ccfd8";
        thm_iris="#c4a7e7";
        thm_hl_low="#21202e";
        thm_hl_med="#403d52";
        thm_hl_high="#524f67";

    fi

    # Aggregating all commands into a single array
    local tmux_commands=()

    # Status bar
    set "status" "on"
    set status-style "fg=$thm_pine,bg=$thm_base"
    set status-left-length "200"
    set status-right-length "200"

    # Theoretically messages (need to figure out color placement)
    set message-style "fg=$thm_muted,bg=$thm_base"
    set message-command-style "fg=$thm_base,bg=$thm_gold"

    # Pane styling
    set pane-border-style "fg=$thm_hl_high"
    set pane-active-border-style "fg=$thm_gold"
    set display-panes-active-colour "${thm_text}"
    set display-panes-colour "${thm_gold}"

    # Windows
    setw window-status-style "fg=${thm_iris},bg=default"
    setw window-status-activity-style "fg=${thm_base},bg=${thm_rose}"
    setw window-status-current-style "fg=${thm_gold},bg=default"

    # Transparency enabling for status bar
    local bar_bg_disable
    bar_bg_disable="$(get_tmux_option "@theme_manager_bar_bg_disable" "")"
    readonly bar_bg_disable

    # Transparent option for status bar
    local bar_bg_disabled_color_option
    bar_bg_disabled_color_option="$(get_tmux_option "@theme_manager_bar_bg_disabled_color_option" "default")"
    readonly bar_bg_disabled_color_option

    if [[ "$bar_bg_disable" == "on" ]]; then
        set status-style "fg=$thm_pine,bg=$bar_bg_disabled_color_option"
    fi

    # Widgets

    local left_column
    local right_column

    local right_column_spacer
    right_column_spacer="$(get_tmux_option "@theme_manager_right_column_spacer" " ")"

    # Show working directory

    local show_directory
    show_directory="$(get_tmux_option "@theme_manager_directory" "")"

    local directory
    readonly directory='#(tmux display-message -p "#{pane_current_path}" | sed "s|$HOME|~|")'

    if [[ "$show_directory" == "on" ]]; then
        right_column=$right_column$right_column_spacer$directory
    fi

    # Show time
    
    local show_time
    show_time="$(get_tmux_option "@theme_manager_time" "")"

    local time
    readonly time='%H:%M'

    if [[ "$show_time" == "on" ]]; then
        right_column=$right_column$right_column_spacer$time
    fi


    set status-left "$left_column"
    set status-right "$right_column"

    # Run all commands
    tmux "${tmux_commands[@]}"

}

main "$@"
