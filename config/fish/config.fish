# Hide welcome message & ensure we are reporting fish as shell
set fish_greeting
set VIRTUAL_ENV_DISABLE_PROMPT "1"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -x SHELL /usr/bin/fish

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

# Replace ls with eza
alias ls 'eza -l --color=always --icons' # preferred listing
alias la 'eza -la --color=always --icons' # preferred listing

# Get fastest mirrors
alias mirror 'sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist'
alias mirror-tor 'sudo torify reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist'

function hexdec
    printf "%d\n" "0x$argv"
end

function dechex
    printf "%x\n" "$argv"
end
