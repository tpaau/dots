set fish_greeting
set VIRTUAL_ENV_DISABLE_PROMPT "1"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -x SHELL /usr/bin/fish
export (envsubst < .env)

function fish_prompt
    set_color green
    echo -n (whoami) 
    set_color white
    echo -n "@"
    echo -n (hostname) ""
    set_color blue
    echo -n (prompt_pwd)
    set_color normal
    echo -n ' >> '
end


# Some command replacements
alias ls 'eza -l --color=always --icons'
alias la 'eza -la --color=always --icons'
alias grep 'grep -i'


# Launch programs with flatpak
alias steam 'flatpak run com.valvesoftware.Steam'
alias discord 'flatpak run com.discordapp.Discord'
alias obs-flat 'flatpak run flathub com.obsproject.Studio'
alias mullvad 'flatpak run net.mullvad.MullvadBrowser'


# Custom commands
alias del0 'find . -type f -size 0c -delete'
alias setrandmac 'sudo ip link set wlp4s0 down && sudo macchanger -r wlp4s0 && sudo ip link set wlp4s0 up'
alias randmac 'python3 ~/Documents/pythonscripts/randmac/rand_mac.py'
alias myip 'curl api.ipify.org'


# Get fastest mirrors
alias mirror 'sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist'
alias mirror-tor 'sudo torify reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist'
alias nano 'nvim' # I don't wanna change 'nano' to 'nvim' when I'm pasting something from ChatGPT
