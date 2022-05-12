#u Load universal config when it's changed

set -l fish_config_mtime
if test -d /Applications
    set fish_config_mtime (/usr/bin/stat -f %m $__fish_config_dir/config.fish)
else
    set fish_config_mtime (/usr/bin/stat -c %Y $__fish_config_dir/config.fish)
end

set -gx EDITOR (which nvim)
set -gx VISUAL $EDITOR
set -gx SUDO_EDITOR $EDITOR

if test "$fish_config_changed" = "$fish_config_mtime"
    exit
else
    set -U fish_config_changed $fish_config_mtime
end

set -Ux fish_user_paths
# Path
fish_add_path ~/.cargo/bin
fish_add_path ~/.local/bin
fish_add_path ~/Library/Python/3.{8,9}/bin
fish_add_path /usr/local/opt/sqlite/bin
fish_add_path /usr/local/sbin
fish_add_path ~/.gem/ruby/2.6.0/bin
fish_add_path ~/.local/bin/pnpm
fish_add_path /bin

# Fish
set -U fish_emoji_width 2
alias -s fish_greeting color-test

# Emacs
# set -l emacs_path /Applications/Emacs.app/Contents/MacOS
# set -Ux EMACS $emacs_path/Emacs
fish_add_path ~/.emacs.d/bin
# alias -s emacs $EMACS

# Go
set -Ux GOPATH ~/go
fish_add_path $GOPATH $GOPATH/bin


fish_add_path -m /etc/profiles/per-user/folke/bin /run/current-system/sw/bin
# Exports
set -Ux LESS -rF
set -Ux BAT_THEME Dracula
set -Ux COMPOSE_DOCKER_CLI_BUILD 1
set -Ux HOMEBREW_NO_AUTO_UPDATE 1
set -Ux DOTDROP_AUTOUPDATE no
set -Ux MANPAGER "nvim +Man!"
set -Ux MANROFFOPT -c
set -Ux OPENCV_LOG_LEVEL ERROR
#set -Ux MANPAGER "sh -c 'col -bx | bat -l man -p'" # use bat to format man pages
#set -Ux MANPAGER "most" # use bat to format man pages

# Dnf
abbr dnfi 'sudo dnf install'
abbr dnfs 'sudo dnf search'
abbr dnfr 'sudo dnf remove'
abbr dnfu 'sudo dnf upgrade --refresh'

# Tmux
abbr t tmux
abbr tc 'tmux attach'
abbr ta 'tmux attach -t'
abbr tad 'tmux attach -d -t'
abbr ts 'tmux new -s'
abbr tl 'tmux ls'
abbr tk 'tmux kill-session -t'
abbr mux tmuxinator

# Files & Directories
abbr mv "mv -iv"
abbr cp "cp -riv"
abbr mkdir "mkdir -vp"
alias -s ls="exa --color=always --icons --group-directories-first"
alias -s la 'exa --color=always --icons --group-directories-first --all'
alias -s ll 'exa --color=always --icons --group-directories-first --all --long'
abbr l ll
abbr ncdu "ncdu --color dark"

# Editor
abbr vim nvim
abbr vi nvim
abbr v nvim
abbr sv sudoedit
abbr vudo sudoedit

# Dev
abbr git hub
abbr g hub
abbr lg lazygit
abbr gl 'hub l --color | devmoji --log --color | less -rXF'
abbr st "hub st"
abbr push "hub push"
abbr pull "hub pull"
alias -s tn "npx --no-install ts-node --transpile-only"
abbr tt "tn src/tt.ts"
alias -s todo "ag --color-line-number '1;36' --color-path '1;36' --print-long-lines --silent '((//|#|<!--|;|/\*|^)\s*(TODO|FIXME|FIX|BUG|UGLY|HACK|NOTE|IDEA|REVIEW|DEBUG|OPTIMIZE)|^\s*- \[ \])'"

alias -s winboot "grub2-reboot \"Windows Boot Manager (on /dev/nvme0n1p1)\"; sudo reboot"

# Other
abbr df "grc /bin/df -h"
abbr ntop "ultra --monitor"
abbr ytop btm
abbr gotop btm
abbr fda "fd -IH"
abbr rga "rg -uu"
abbr grep rg
abbr suod sudo
abbr helpme "bat ~/HELP.md"
abbr weather "curl -s wttr.in/Ghent | grep -v Follow"
abbr show-cursor "tput cnorm"
abbr hide-cursor "tput civis"
abbr aria2c-daemon "aria2c -D"
