# Emacs
set -l emacs_path /Applications/Emacs.app/Contents/MacOS
set -x EMACS $emacs_path/Emacs
set -p PATH $emacs_path/bin ~/.emacs.d/bin
alias emacs $EMACS

set -x GOPATH ~/go
set -p PATH $GOPATH $GOPATH/bin

set -p PATH ~/.cargo/bin
set -p PATH ~/.local/bin
set -p PATH ~/Library/Python/3.{8,9}/bin
set -p PATH /usr/local/opt/sqlite/bin
set -p PATH /usr/local/sbin
set -p PATH ~/.gem/ruby/2.6.0/bin
set -p PATH ~/.local/bin/pnpm
fnm env --shell=fish --use-on-cd | source
set -p PATH ~/.local/bin/pnpm # make sure to prepend pnpm bin path to override fnm

if status --is-interactive
    # Bat Configuration
    set -x BAT_THEME "Dracula"
    # set -x MANROFFOPT "-c"
    # set -x MANPAGER "sh -c 'col -bx | bat -l man -p'" # use bat to format man pages
    #set -x MANPAGER "most" # use bat to format man pages
    set -x MANPAGER "nvim -u NORC +Man!"

    # Tmux
    abbr -g ta 'tmux attach -t'
    abbr -g tad 'tmux attach -d -t'
    abbr -g ts 'tmux new-session -s'
    abbr -g tl 'tmux list-sessions'
    abbr -g tksv 'tmux kill-server'
    abbr -g tkss 'tmux kill-session -t'
    abbr -g mux 'tmuxinator'
    abbr -g suod sudo

    # Changing Directories
    alias ls="exa --icons --group-directories-first"
    alias la 'exa --icons --group-directories-first --all'
    alias ll 'exa --icons --group-directories-first --all --long'
    abbr -g l 'll'

    # Editor
    abbr -g vim 'nvim'
    abbr -g vi 'nvim'
    set -x EDITOR nvim

    # Dev
    abbr -g git 'hub'
    abbr -g g 'git'
    abbr -g gl 'git l --color | devmoji --log --color | less -rXF'
    abbr -g push "git push"
    abbr -g pull "git pull"
    alias tn "npx --no-install ts-node --transpile-only"
    abbr -g tt "tn src/tt.ts"
    abbr -g code "code-insiders"
    alias todo "ag --color-line-number '1;36' --color-path '1;36' --print-long-lines --silent '((//|#|<!--|;|/\*|^)\s*(TODO|FIXME|FIX|BUG|UGLY|HACK|NOTE|IDEA|REVIEW|DEBUG|OPTIMIZE)|^\s*- \[ \])'"
    abbr -g ntop "ultra --monitor"
    abbr -g ytop "btm"
    abbr -g gotop "btm"
    abbr -g fda "fd -IH"
    abbr -g rga "rg -uu"
    abbr -g grep "rg"

    abbr -g helpme "bat ~/HELP.md"
    abbr -g weather "curl -s wttr.in/Ghent | grep -v Follow"

    # Docker
    set -x COMPOSE_DOCKER_CLI_BUILD 1

    # Fedora
    #abbr -g dnfs "sudo dnf search"
    #abbr -g dnfi "sudo dnf install"
    #abbr -g dnfu "sudo dnf update --refresh"

    abbr -g "show-cursor" "tput cnorm"
    abbr -g "hide-cursor" "tput civis"
    abbr -g "aria2c-daemon" "aria2c -D"

    set -g fish_emoji_width 2

    function fish_greeting
        color-test
    end

    function __fish_pwd
        pwd | sed "s|^$HOME|~|"
    end

    function yabai_fix
        pgrep yabai | tail -n +2 | head -n1 | xargs kill
    end

    set -x HOMEBREW_NO_AUTO_UPDATE 1
    set -x DOTDROP_AUTOUPDATE no
    alias dotdrop "command dotdrop -c ~/projects/dot/dotdrop.yaml"
    alias dotgit "hub -C ~/projects/dot/"
end
