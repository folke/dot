# Bat Configuration
set -x BAT_THEME "Dracula"
# set -x MANROFFOPT "-c"
# set -x MANPAGER "sh -c 'col -bx | bat -l man -p'" # use bat to format man pages
#set -x MANPAGER "most" # use bat to format man pages
set -x MANPAGER "nvim -u NORC +Man!"

# Path
# set -x PATH $PATH /usr/local/opt/ruby/bin /usr/local/lib/ruby/gems/2.6.0/bin
set -x PATH $PATH ~/go/bin
set -x PATH $PATH ~/bin
set -x PATH $PATH ~/.cargo/bin
set -x PATH $PATH ~/.local/bin
set -x PATH $PATH ~/.config/folke/bin
set -x PATH $PATH ~/.config/scripts/bin
set -x PATH /usr/local/sbin $PATH

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
alias ls="gls --group-directories-first --color=always"
alias grep 'grep --color'
alias la 'exa --all --icons --group-directories-first'
alias ll 'exa --all --icons --group-directories-first --long'
abbr l 'll'

# Editor
abbr vim 'nvim'
abbr vi 'nvim'
set -x EDITOR nvim

# Dev
abbr git 'hub'
abbr g 'git'
abbr gl 'git l --color | devmoji --log --color | less -rXF'
abbr push "git push"
abbr pull "git pull"
alias dot 'hub --git-dir=$HOME/.dot --work-tree=$HOME'
alias tn "npx --no-install ts-node --transpile-only"
abbr tt "tn src/tt.ts"
abbr code "code-insiders"
abbr todo "ag --color-line-number '1;36' --color-path '1;36' --print-long-lines --silent '((//|#|<!--|;|/\*|^)\s*(TODO|FIXME|FIX|BUG|UGLY|HACK|NOTE|IDEA|REVIEW|DEBUG|OPTIMIZE)|^\s*- \[ \])'"
abbr ntop "ultra --monitor"
abbr ytop "btm"
abbr gotop "btm"

abbr helpme "bat ~/HELP.md"
abbr weather "curl -s wttr.in/Ghent | grep -v Follow"

# Github Completions
# gh completion -s fish | source

# Fedora
#abbr dnfs "sudo dnf search"
#abbr dnfi "sudo dnf install"
#abbr dnfu "sudo dnf update --refresh"

# Navi
navi widget fish | source

# Update
function update -d "Update homebrew, fish, pnpm"
    echo "[update] Homebrew"
    brew update
    and brew upgrade
    and brew cleanup

    and echo "[update] nodejs"
    and pnpm update -g

    and echo "[update] tldr"
    and tldr -u

    and echo "[update] fish"
    and fisher self-update
    and fisher
    and fish_update_completions
end

abbr system "neofetch --source ~/Pictures/Cyberpunk/connected-wallpaper-1920x1080.jpg"

function corona
    tput civis
    while true
        set stats (curl "https://corona-stats.online/Belgium?source=2" --silent | head -n 7)
        clear
        for line in $stats
            echo $line
        end
        tput cuu1
        sleep 30
    end
end

function dot.untracked
    dot ls-files -t --other --exclude-standard $argv[1]
end


function dot.all
    dot status -s -unormal
end

function dot.status
    dot status -s -uno ~
    for d in ~/.config/*
        if dot ls-files --error-unmatch $d &>/dev/null
            dot.untracked $d
        end
    end
    dot.untracked ~/.SpaceVim.d/
end

abbr show-cursor "tput cnorm"
abbr hide-cursor "tput civis"

set -g fish_emoji_width 2

# Dracula Theme
if test -e ~/.config/fish/functions/dracula.fish
  builtin source ~/.config/fish/functions/dracula.fish
end

test -r "~/.dir_colors" && eval (dircolors ~/.dir_colors)

function color-test
    set scripts square crunch alpha spectrum unowns.py ghosts monster
    set script "$HOME/projects/color-scripts/color-scripts/"(random choice $scripts)
    $script
end

function fish_greeting
    color-test
end

function yabai_restart
  killall yabai
  killall Dock
  pgrep yabai
  #brew services yabai restart
end

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true

starship init fish | source

# fnm
set PATH $PATH ~/.fnm
fnm env --multi | source
set PATH ~/.local/bin/pnpm $PATH
