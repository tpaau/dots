#!/bin/bash

notify_user()
{
    echo "$1"
    notify-send -u low "$1"
}

reload_theme()
{
    notify_user "Reloading theme."
    bash -c ~/.config/tpaau-17DB-scripts/theme-switcher/reload-waybar.sh
}

next_theme()
{
    notify_user "Option 'next' is not implemented yet."
}

prev_theme()
{
    notify_user "Option 'previous' is not implemented yet."
}

theme_file="/home/mikolaj/.config/tpaau-17DB-scripts/theme-switcher/data/current-theme"

default_theme="solid black, static waybar"

if [[ -z "$(cat "$theme_file")" ]]; then
    notify_user "Cannot detect current theme; switching to default."
    echo $default_theme > $theme_file
fi

if [[ $1 == "reload" ]]; then
    reload_theme
elif [[ $1 == "next" ]]; then
    next_theme
elif [[ $1 == "previous" ]]; then
    prev_theme
elif [ $# -lt 1 ]; then
    notify_user "Expected an argument!"
else
    notify_user "Unknow option '${1}'"
fi
    
exit 0
