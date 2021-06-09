#u Load universal config when it's changed
set -l fish_config_mtime (/usr/bin/stat -f %m $__fish_config_dir/config.fish)

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


fish_add_path -m ~/.nix-profile/bin /etc/profiles/per-user/folke/bin /run/current-system/sw/bin /nix/var/nix/profiles/default/bin
# Exports
set -Ux EDITOR nvim
set -Ux VISUAL nvim
set -Ux LESS -rF
set -Ux BAT_THEME Dracula
set -Ux COMPOSE_DOCKER_CLI_BUILD 1
set -Ux HOMEBREW_NO_AUTO_UPDATE 1
set -Ux DOTDROP_AUTOUPDATE no
set -Ux MANPAGER "nvim +Man!"
set -Ux MANROFFOPT -c
#set -Ux MANPAGER "sh -c 'col -bx | bat -l man -p'" # use bat to format man pages
#set -Ux MANPAGER "most" # use bat to format man pages


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

# Nix
abbr ni "nix-env -f '<nixpkgs>' -iA"
abbr nq "nix-env -q"
abbr nqa "nix-env -qa"
abbr nd "nix-env -e"
abbr nu "nix-env -u"

# Other
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
alias -s dotdrop "command dotdrop -c ~/projects/dot/dotdrop.yaml"
alias -s dotgit "hub -C ~/projects/dot/"
alias -s apropos "MANPATH=$HOME/.cache/fish command apropos"
alias -s whatis "MANPATH=$HOME/.cache/fish command whatis"
