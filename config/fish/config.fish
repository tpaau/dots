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
    echo -n " ["
    set_color red
    echo -n $status
    set_color normal
    echo -n '] >> '
end


alias ls 'eza -l --color=always --icons'
alias la 'eza -la --color=always --icons'

alias del0 'find . -type f -size 0c -delete'
alias randmac 'python3 ~/Documents/pythonscripts/randmac/rand_mac.py' # generate a random MAC address
alias pinga 'ping -A'
alias myip 'curl api.ipify.org' #show ip
alias exitip 'torsocks curl api.ipify.org' #show exit node ip
alias gtfo 'echo "Getting the fuck out." ; shutdown -P now'


# Get fastest mirrors
alias mirror 'sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist'
alias mirror-tor 'sudo torify reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist'
alias nano 'nvim'
alias newsboat 'torify newsboat'


# Still working on it
function hexdec
    printf "%d\n" "0x$argv"
end

function dechex
    printf "%x\n" "$argv"
end
