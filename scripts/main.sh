#!/usr/bin/env bash

onedark_black="#282c34"
onedark_blue="#61afef"
onedark_yellow="#e5c07b"
onedark_red="#e06c75"
onedark_white="#aab2bf"
onedark_green="#98c379"
onedark_visual_grey="#3e4452"
onedark_comment_grey="#5c6370"

source $current_dir/scripts/getIP.sh
source $current_dir/scripts/getRamUsage.sh
source $current_dir/scripts/getDate.sh
source $current_dir/scripts/getHostname.sh
source $current_dir/scripts/getGit.sh

# Obtener el valor de una opción con un valor predeterminado
get() {
    local option=$1
    local default_value=$2
    local option_value="$(tmux show-option -gqv "$option")"
    echo "${option_value:-$default_value}"
}

# Configuraciones globales de tmux
tmux set-option -gq status on
tmux set-option -gq status-justify left

tmux set-option -gq status-left-length 100
tmux set-option -gq status-right-length 100
tmux set-option -gq status-right-attr none

tmux set-option -gq message-fg "$onedark_white"
tmux set-option -gq message-bg "$onedark_black"

tmux set-option -gq message-command-fg "$onedark_white"
tmux set-option -gq message-command-bg "$onedark_black"

tmux set-option -gq status-attr none
tmux set-option -gq status-left-attr none

tmux set-window-option -gq window-status-fg "$onedark_black"
tmux set-window-option -gq window-status-bg "$onedark_black"
tmux set-window-option -gq window-status-attr none

tmux set-window-option -gq window-status-activity-bg "$onedark_black"
tmux set-window-option -gq window-status-activity-fg "$onedark_black"
tmux set-window-option -gq window-status-activity-attr none

tmux set-window-option -gq window-status-separator ""

tmux set-option -gq window-style "fg=$onedark_comment_grey"
tmux set-option -gq window-active-style "fg=$onedark_white"

tmux set-option -gq pane-border-fg "$onedark_white"
tmux set-option -gq pane-border-bg "$onedark_black"
tmux set-option -gq pane-active-border-fg "$onedark_green"
tmux set-option -gq pane-active-border-bg "$onedark_black"

tmux set-option -gq display-panes-active-colour "$onedark_yellow"
tmux set-option -gq display-panes-colour "$onedark_blue"

tmux set-option -gq status-bg "$onedark_black"
tmux set-option -gq status-fg "$onedark_white"

tmux set-option -gq @prefix_highlight_fg "$onedark_black"
tmux set-option -gq @prefix_highlight_bg "$onedark_green"
tmux set-option -gq @prefix_highlight_copy_mode_attr "fg=$onedark_black,bg=$onedark_green"
tmux set-option -gq @prefix_highlight_output_prefix "  "


time_format=$(tmux show-option -gqv "@onedark_date_format")
time_format="${time_format:-'%d/%m/%Y'}"  

previous_status_right=""

render() {
    # Orden de colores predefinido
    colors=("$onedark_visual_grey" "$onedark_green" "$onedark_yellow" "$onedark_red")
    
    # Leer los widgets configurados en tmux.conf
    status_widgets=$(get "@onedark_widgets" "date,ram,ip,hostname")
    
    # Construir status-right dinámicamente
    status_right=""
    previous_bg="$onedark_black"
    i=0
    
    for widget in $(echo $status_widgets | tr ',' ' '); do
        color="${colors[i]}"
        case $widget in
            date)
                # Agregar el widget de fecha
                status_right="$status_right#[fg=$color,bg=$previous_bg]#[fg=$onedark_white,bg=$color] $(get_date "$time_format") "
                ;;
            ram)
                # Agregar el widget de RAM
                status_right="$status_right#[fg=$color,bg=$previous_bg]#[fg=$onedark_black,bg=$color,bold] $(get_ram_usage) "
                ;;
            ip)
                # Agregar el widget de IP
                status_right="$status_right#[fg=$color,bg=$previous_bg]#[fg=$onedark_black,bg=$color,nounderscore,noitalics] $(get_ip) "
                ;;
            hostname)
                # Agregar el widget de Hostname
                status_right="$status_right#[fg=$color,bg=$previous_bg]#[fg=$onedark_black,bg=$color,bold] $(get_hostname) "
                ;;
            git)
                # Agregar el widget de Git
                status_right="$status_right#[fg=$color,bg=$previous_bg]#[fg=$onedark_black,bg=$color,bold] $(get_git) "
                ;;
        esac
        previous_bg="$color"
        i=$(( (i + 1) % ${#colors[@]} )) 
    done

    tmux set-option -gq status-right "$status_right"
    # Actualizar el estado anterior

    tmux set-option -gq status-left "#[fg=$onedark_black,bg=$onedark_green,bold] #S #{prefix_highlight}#[fg=$onedark_green,bg=$onedark_black,nobold,nounderscore,noitalics]"

    tmux set-option -gq window-status-format "#[fg=$onedark_black,bg=$onedark_black,nobold,nounderscore,noitalics]#[fg=$onedark_white,bg=$onedark_black] #I  #W #[fg=$onedark_black,bg=$onedark_black,nobold,nounderscore,noitalics]"

    tmux set-option -gq window-status-current-format "#[fg=$onedark_black,bg=$onedark_visual_grey,nobold,nounderscore,noitalics]#[fg=$onedark_white,bg=$onedark_visual_grey,nobold] #I  #W #[fg=$onedark_visual_grey,bg=$onedark_black,nobold,nounderscore,noitalics]"
}


start_render(){
    while [ 1 ]; do
       render 
       sleep 1 
    done
}

start_render &
