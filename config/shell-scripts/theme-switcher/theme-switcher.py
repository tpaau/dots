#!/bin/python3

import subprocess
import sys
import os

import themes


WAYBAR_STYLE_DIR = os.path.expanduser("~/.config/waybar/style.css")
MAKO_CONFIG_DIR = os.path.expanduser("~/.config/mako/config")

THEME_DIR = os.path.expanduser("~/.config/shell-scripts/theme-switcher/data/")
THEME_FILE = THEME_DIR + "current-theme"
DEFAULT_THEME = "solid black, static waybar"

THEME_NAMES = ["solid black, static waybar", "solid black, floating waybar"]


def exec(command):
    """Executes a shell command in the background without attaching stdout or stderr to the terminal."""
    try:
        print(f"starting: {command}")
        subprocess.Popen(command, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    except Exception as e:
        print(f"Error occurred while executing the command: {e}")


def reload_conf():
    exec("bash -c ~/.config/shell-scripts/theme-switcher/reload-config.sh")


def notify_user(message):
    print(message)
    exec(f"notify-send '{message}'")


def notify_user_err(message):
    print(message)
    exec(f"notify-send -u critical '{message}'")


def print_usage():
    print("theme-swither.py <option>")


def help_message():
    print_usage()
    print("Available options:")
    print("  * reload - reload config")
    print("  * next - switch to next theme")
    print("  * previous - switch to previous theme")
    print("  -h - display this message")


def switch_theme(current_theme: str):
    exec(f"cp {themes.AVAILABLE_THEMES[current_theme].waybar_style} {WAYBAR_STYLE_DIR}")
    exec(f"cp {themes.AVAILABLE_THEMES[current_theme].mako_conf} {MAKO_CONFIG_DIR}")
    exec(f"kitten themes --reload-in=all {themes.AVAILABLE_THEMES[current_theme].kitty_theme}")


def main():
    current_theme = "none"

    try:
        # file where the current theme name is stored
        theme_file = open(THEME_FILE, 'r')
        theme = theme_file.readline().strip()
        if not THEME_NAMES.__contains__(theme):
            notify_user_err(f"File {THEME_FILE} contains and invalid theme: '{theme}'")
            exec(f"mkdir -p {THEME_DIR}")
            exec(f"echo '{DEFAULT_THEME}' > {THEME_FILE}")
        else:
            current_theme = theme
    except Exception as e:
        notify_user_err(f"Failed to open data file {THEME_FILE}")
        print(e)
        exec(f"mkdir -p {THEME_DIR}")
        exec(f"echo '{DEFAULT_THEME}' > {THEME_FILE}")

    if len(sys.argv) != 2:
        print("Expected at least one argument!")
        sys.exit(1)

    option = sys.argv[1]

    if option == "reload":
        reload_conf()
    elif option == "previous":
        notify_user("Option previous is not implemented yet.")
    elif option == "next":
        current_theme_index = THEME_NAMES.index(current_theme)

        if current_theme_index >= len(THEME_NAMES) -1:
            current_theme_index = 0
        else:
            current_theme_index += 1

        current_theme = THEME_NAMES[current_theme_index]
        exec(f"echo '{current_theme}' > {THEME_FILE}")
        switch_theme(current_theme)
        reload_conf()

    elif option == "-h":
        help_message()
        sys.exit(0)
    else:
        print("Invalid option. Specify the '-h' argument to list all available options.")
        sys.exit(1)

if __name__ == "__main__":
    main()
