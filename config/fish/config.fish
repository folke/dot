# Load universal config when it's changed
set -l fish_config_mtime (stat -f %m $__fish_config_dir/config.fish)
if test "$fish_config_changed" = "$fish_config_mtime"
    exit
else
    set -Ux fish_config_changed $fish_config_mtime
end

set -Ux fish_user_paths
# Emacs
set -l emacs_path /Applications/Emacs.app/Contents/MacOS
set -Ux EMACS $emacs_path/Emacs
set -p fish_user_paths $emacs_path/bin ~/.emacs.d/bin
alias -s emacs $EMACS

set -Ux GOPATH ~/go
set -p fish_user_paths $GOPATH $GOPATH/bin

set -p fish_user_paths ~/.cargo/bin
set -p fish_user_paths ~/.local/bin
set -p fish_user_paths ~/Library/Python/3.{8,9}/bin
set -p fish_user_paths /usr/local/opt/sqlite/bin
set -p fish_user_paths /usr/local/sbin
set -p fish_user_paths ~/.gem/ruby/2.6.0/bin
set -p fish_user_paths ~/.local/bin/pnpm

# Bat Configuration
set -Ux BAT_THEME "Dracula"
# set -Ux MANROFFOPT "-c"
# set -Ux MANPAGER "sh -c 'col -bx | bat -l man -p'" # use bat to format man pages
#set -Ux MANPAGER "most" # use bat to format man pages
set -Ux MANPAGER "nvim -u NORC +Man!"

# Tmux
abbr ta 'tmux attach -t'
abbr tad 'tmux attach -d -t'
abbr ts 'tmux new-session -s'
abbr tl 'tmux list-sessions'
abbr tksv 'tmux kill-server'
abbr tkss 'tmux kill-session -t'
abbr mux 'tmuxinator'
abbr suod sudo

# Changing Directories
alias -s ls="exa --icons --group-directories-first"
alias -s la 'exa --icons --group-directories-first --all'
alias -s ll 'exa --icons --group-directories-first --all --long'
abbr l 'll'

# Editor
abbr vim 'nvim'
abbr vi 'nvim'
set -Ux EDITOR nvim
set -Ux VISUAL nvim

# Dev
abbr git 'hub'
abbr g 'git'
abbr gl 'git l --color | devmoji --log --color | less -rXF'
abbr st "git st"
abbr push "git push"
abbr pull "git pull"
alias -s tn "npx --no-install ts-node --transpile-only"
abbr tt "tn src/tt.ts"
abbr code "code-insiders"
alias -s todo "ag --color-line-number '1;36' --color-path '1;36' --print-long-lines --silent '((//|#|<!--|;|/\*|^)\s*(TODO|FIXME|FIX|BUG|UGLY|HACK|NOTE|IDEA|REVIEW|DEBUG|OPTIMIZE)|^\s*- \[ \])'"
abbr ntop "ultra --monitor"
abbr ytop "btm"
abbr gotop "btm"
abbr fda "fd -IH"
abbr rga "rg -uu"
abbr grep "rg"

abbr helpme "bat ~/HELP.md"
abbr weather "curl -s wttr.in/Ghent | grep -v Follow"

# Docker
set -Ux COMPOSE_DOCKER_CLI_BUILD 1

# Fedora
#abbr dnfs "sudo dnf search"
#abbr dnfi "sudo dnf install"
#abbr dnfu "sudo dnf update --refresh"

abbr "show-cursor" "tput cnorm"
abbr "hide-cursor" "tput civis"
abbr "aria2c-daemon" "aria2c -D"

set -Ux fish_emoji_width 2

alias -s fish_greeting color-test

set -Ux HOMEBREW_NO_AUTO_UPDATE 1
set -Ux DOTDROP_AUTOUPDATE no
alias -s dotdrop "command dotdrop -c ~/projects/dot/dotdrop.yaml"
alias -s dotgit "hub -C ~/projects/dot/"
