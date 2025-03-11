# Dotfiles

**My Hyprland desktop dotfiles with a custom theme switcher!**


DISCLAIMER: The theme switcher and the install script are unfinished. **Use them at your own risk!**


## My Setup

* **OS**: Arch Linux
* **Shell**: Fish
* **Terminal**: Kitty
* **Compositor**: Hyprland
* **Bar**: Waybar
* **Font**: Hack Nerd Font
* **Launcher**: Wofi
* **Lock**: Swaylock
* **Session Management**: Wlogout
* **Notifications**: Mako


## Screenshots

![Fastfetch](https://github.com/tpaau-17DB/Dotfiles/blob/main/screenshots/fastfetch-screenshot-11.3.2025.png?raw=true)

<details>
<summary>outdated</summary>

![Screenshot](https://github.com/tpaau-17DB/Dotfiles/blob/main/screenshots/overlord-screen.png?raw=true)

![Coding Setup](https://github.com/tpaau-17DB/Dotfiles/blob/main/screenshots/nvim-setup.png?raw=true)
Neovim Setup

![Fastfetch](https://github.com/tpaau-17DB/Dotfiles/blob/main/screenshots/fastfetch-config.png?raw=true)
Fastfetch
</details>


## Shortcuts

* ⌘ + Q: launch kitty terminal
* ⌘ + L: lock screen
* ⌘ + M: launch wlogout
* ⌘ + E: open nemo file browser
* ⌘ + S: screenshot
* ⌘ + SPACE: launch wofi
* ⌘ + V: toggle floating window
* ⌘ + P: toggle pseudotiling
* ⌘ + J: toggle splitting axis
* ⌘ + SHIFT + M: force quit hyprland
* ⌘ + X: kill active window
* ⌘ + ARROWS: navigate windows
* ⌘ + 1-9: switch between workspaces
* ⌘ + SHIFT + 1-9: move windows between workspaces
* ⌘ + MOUSE_SCROLL: switch between workspaces
* ⌘ + MOUSE_LEFT: move window
* ⌘ + MOUSE_RIGHT: resize window
* ⌘ + R: reload theme
* ⌘ + T: next theme
* ALT + RIGHT: next song
* ALT + LEFT: previous song
* ALT + SPACE: play/pause song


## Installing

To install the dotfiles, run:
```
./install.sh
```

If the script detects that you are using Arch Linux, it will prompt you to install all
dependencies using `yay`.

If you just want to install the dependencies, run:
```
<package-manager install> $(cat requirements.txt)
```
Note that package names may differ between distributions.


## Credits

* Waybar, wofi, mako, hypr, swaylock and wlogout config files based on default HyprV config files (https://github.com/soldoestech/hyprv4)
* OLD: Neofetch config base: https://github.com/AlguienSasaki/Dotfiles
