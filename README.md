# Dotfiles

**My Hyprland desktop dotfiles with a custom theme switcher!**


DISCLAIMER: This project is still in development. It may contain bugs and unfinished features.


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

![Screenshot](https://github.com/tpaau-17DB/Dotfiles/blob/main/screenshots/overlord-screen.png?raw=true)

<details>
<summary>outdated</summary>

![Coding Setup](https://github.com/tpaau-17DB/Dotfiles/blob/main/screenshots/nvim-setup.png?raw=true)
Neovim Setup


![Fastfetch](https://github.com/tpaau-17DB/Dotfiles/blob/main/screenshots/fastfetch-config.png?raw=true)
Fastfetch
</details>


## Shortcuts

* `SUPER + Q` - launch kitty terminal
* `SUPER + L` - lock screen
* `SUPER + M` - launch wlogout
* `SUPER + E` - open nemo file browser
* `SUPER + S` - screenshot
* `SUPER + SPACE` - launch wofi
* `SUPER + V` - toggle floating windows
* `SUPER + P` - toggle pseudotiling
* `SUPER + J` - toggle splitting axis
* `SUPER + SHIFT + M` - force quit hyprland
* `SUPER + X` - kill active window
* `SUPER + ARROWS` - navigate windows
* `SUPER + 1-9` - switch between workspaces
* `SUPER + SCROLL` - switch between workspaces
* `SUPER + SHIFT + 1-9` - move windows between workspaces
* `SUPER + MOUSE_LEFT` - move window
* `SUPER + MOUSE_RIGHT` - resize window

* `SUPER + R` - reload theme
* `SUPER + T` - next theme
* `ALT + RIGHT` - next song
* `ALT + LEFT` - previous song
* `ALT + SPACE` - pause song


## Requirements

This is a brief list of requirements, it might be incomplete.

<details>
<summary>Essential requirements</summary>

* hyprland
* kitty
* waybar
* mako
* swaylock-effects
* wofi
* hyprpaper
* playerctl
* libnotify
* python3
* python-psutil
* wl-clipboard
</details>

<details>
<summary>Optional requirements</summary>

* neovim
* fastfetch
* fish
* grim
* nerd-fonts
</details>


## Installing

To install the dotfiles, run:
```
./install.sh
```

If the script detects that you use Arch Linux,
it will attempt to install all dependencies using
`pacman` and `yay`.


## Credits

* Waybar, wofi, mako, hypr, swaylock and wlogout config files based on default HyprV config files (https://github.com/soldoestech/hyprv4)
* OLD: Neofetch config base: https://github.com/AlguienSasaki/Dotfiles
