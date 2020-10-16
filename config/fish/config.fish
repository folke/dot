
# Path
set -x GOPATH ~/go
set -p PATH ~/go/bin
set -p PATH ~/bin
set -p PATH ~/.cargo/bin
set -p PATH ~/.emacs.d/bin
set -p PATH ~/.local/bin
set -p PATH ~/.config/folke/bin
set -p PATH ~/.config/scripts/bin
set -p PATH ~/Library/Python/3.8/bin
set -p PATH ~/Library/Python/3.9/bin
set -p PATH /usr/local/opt/sqlite/bin
set -p PATH /usr/local/sbin
set -p PATH ~/.gem/ruby/2.6.0/bin
set -p PATH ~/.local/bin/pnpm $PATH
set -p PATH $GOPATH


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
    alias ls="gls --group-directories-first --color=always"
    alias grep 'grep --color'
    alias la 'exa --all --icons --group-directories-first'
    alias ll 'exa --all --icons --group-directories-first --long'
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
    abbr -g aga "ag -u"
    abbr -g rga "rg -uu"

    abbr -g helpme "bat ~/HELP.md"
    abbr -g weather "curl -s wttr.in/Ghent | grep -v Follow"

    # Fedora
    #abbr -g dnfs "sudo dnf search"
    #abbr -g dnfi "sudo dnf install"
    #abbr -g dnfu "sudo dnf update --refresh"

    abbr -g "show-cursor" "tput cnorm"
    abbr -g "hide-cursor" "tput civis"
    abbr -g "aria2c-daemon" "aria2c -D"

    set -g fish_emoji_width 2

    test -r "~/.dir_colors" && eval (dircolors ~/.dir_colors)

    function fish_greeting
        color-test
    end

    function yabai_fix
        pgrep yabai | tail -n +2 | head -n1 | xargs kill
    end

    set -x HOMEBREW_NO_AUTO_UPDATE 1
    set -x DOTDROP_AUTOUPDATE no
    alias dotdrop "command dotdrop -c ~/projects/dot/dotdrop.yaml"
    alias dotgit "hub -C ~/projects/dot/"

    # tabtab source for packages
    # uninstall by removing these lines
    [ -f ~/.config/tabtab/fish/__tabtab.fish ]; and source ~/.config/tabtab/fish/__tabtab.fish; or true

    # Navi
    navi widget fish | source
    fnm env --multi | source
    starship init fish | source
end
