# @fish-lsp-disable 2002

status is-interactive; or exit

# Load secrets if available
dotenv ~/dot/secrets.env

# Cursor styles
set -gx fish_vi_force_cursor 1
set -gx fish_cursor_default block
set -gx fish_cursor_insert line blink
set -gx fish_cursor_visual block
set -gx fish_cursor_replace_one underscore

# Path
set -e fish_user_paths
# fish_add_path /bin
fish_add_path ~/.cargo/bin
fish_add_path ~/.bun/bin
fish_add_path ~/.local/bin
fish_add_path ~/.luarocks/bin
fish_add_path ~/Library/Python/3.{8,9}/bin
fish_add_path /usr/local/opt/sqlite/bin
fish_add_path /usr/local/sbin
fish_add_path ~/.gem/ruby/2.6.0/bin
fish_add_path /var/lib/flatpak/exports/bin/
fish_add_path ~/.dotnet/tools
fish_add_path ~/.local/share/mise/shims

set -gx DENO_INSTALL "~/.deno"
fish_add_path ~/.deno/bin

set -gx EDITOR (which nvim)
set -gx VISUAL $EDITOR
set -gx SUDO_EDITOR $EDITOR

# Fish
set fish_emoji_width 2
alias ssh "TERM=xterm-256color command ssh"
alias mosh "TERM=xterm-256color command mosh"

# Emacs
# set -l emacs_path /Applications/Emacs.app/Contents/MacOS
# set -Ux EMACS $emacs_path/Emacs
fish_add_path ~/.emacs.d/bin
# alias emacs $EMACS

# Go
set -x GOPATH ~/go
fish_add_path $GOPATH $GOPATH/bin

fish_add_path -m /etc/profiles/per-user/folke/bin /run/current-system/sw/bin
# Exports
set -x LESS -rF
set -x COMPOSE_DOCKER_CLI_BUILD 1
set -x HOMEBREW_NO_AUTO_UPDATE 1
set -x DOTDROP_AUTOUPDATE no
set -x MANPAGER "nvim +Man!"
set -x MANROFFOPT -c
set -x OPENCV_LOG_LEVEL ERROR
#set -x MANPAGER "sh -c 'col -bx | bat -l man -p'" # use bat to format man pages
#set -x MANPAGER "most" # use bat to format man pages
#
abbr -a --position anywhere --set-cursor -- -h "-h 2>&1 | bat --plain --language=help"
abbr j just

# Tmux
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
alias ls="eza --color=auto --icons=auto --group-directories-first"
alias la 'eza --color=auto --icons=auto --group-directories-first --all --git'
alias ll 'eza --color=auto --icons=auto --group-directories-first --all --git --long'
abbr l ll
abbr ncdu "ncdu --color dark"
abbr b btm
abbr h htop

# Editor
abbr vim nvim
abbr vi nvim
abbr v nvim
alias vimpager 'nvim - -c "lua require(\'util\').colorize()"'
abbr vd "VIM=~/projects/neovim nvim --luamod-dev"
abbr sv sudoedit
abbr vudo sudoedit
abbr v! sudoedit
alias lazyvim "NVIM_APPNAME=lazyvim nvim"
abbr lv lazyvim
alias bt "coredumpctl -1 gdb -A '-ex \"bt\" -q -batch' 2>/dev/null | awk '/Program terminated with signal/,0' | bat -l cpp --no-pager --style plain"

# Dev
abbr topgit topgrade --only git_repos
abbr g git

set -x LG_CONFIG_FILE /home/folke/.config/lazygit/config.yml,/home/folke/.cache/nvim/lazygit-theme.yml

alias lazygit "TERM=xterm-256color command lazygit"
abbr gg lazygit
abbr gl 'git l --color | devmoji --log --color | less -rXF'
abbr gs "git st"
abbr gb "git checkout -b"
abbr gc "git commit"
abbr gpr "gh pr checkout"
abbr gm "git branch -l main | rg main > /dev/null 2>&1 && git checkout main || git checkout master"
abbr gcp "git commit -p"
abbr gpp "git push"
abbr gp "git pull"
alias tn "npx --no-install ts-node --transpile-only"
abbr tt "tn src/tt.ts"

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
alias gnome-control-center "env XDG_CURRENT_DESKTOP=GNOME gnome-control-center"

# systemctl
abbr s systemctl
abbr scu "systemctl --user"
abbr ss "command systemctl status"
abbr sl "systemctl --type service --state running"
abbr se "sudo systemctl enable --now"
abbr sd "sudo systemctl disable --now"
abbr sr "sudo systemctl restart"
abbr so "sudo systemctl stop"
abbr sa "sudo systemctl start"
abbr slu "systemctl --user --type service --state running"
abbr seu "systemctl --user enable --now"
abbr sdu "systemctl --user disable --now"
abbr sru "systemctl --user restart"
abbr sou "systemctl --user stop"
abbr sau "systemctl --user start"
abbr sf "systemctl --failed --all"

# journalctl
abbr jb "journalctl -b"
abbr jf "journalctl --follow -n 100"
abbr jg "journalctl -b --grep"
abbr ju "journalctl --all --follow -n 100 --unit"
abbr juu "journalctl --all --follow -n 100 --user-unit"

# paru
abbr p paru
abbr pai "paru -S"
abbr par "paru -Rns"
abbr pas "paru -Ss"
abbr pal "paru -Q"
abbr paf "paru -Ql"
abbr pao "paru -Qo"
