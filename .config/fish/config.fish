# Bat Configuration
set -x BAT_THEME "Dracula"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'" # use bat to format man pages

# Path
set -x PATH $PATH /usr/local/opt/ruby/bin /usr/local/lib/ruby/gems/2.6.0/bin
set -x PATH $PATH /Users/folke/go/bin
set -x PATH /usr/local/sbin $PATH

# Tmux
abbr ta 'tmux attach -t'
abbr tad 'tmux attach -d -t'
abbr ts 'tmux new-session -s'
abbr tl 'tmux list-sessions'
abbr tksv 'tmux kill-server'
abbr tkss 'tmux kill-session -t'
abbr mux 'tmuxinator'

# Changing Directories
alias ls="gls --group-directories-first --color=always"
abbr grep 'grep --color'
abbr la 'exa --all --icons --group-directories-first'
abbr ll 'exa --all --icons --group-directories-first --long'
abbr l 'll'

# Editor
abbr vim 'nvim'
abbr vi 'nvim'
set -x EDITOR nvim

# Dev
abbr git 'hub'
abbr g 'git'
abbr gl 'g l --color | devmoji --log --color | less -rXF'
abbr push "git push"
abbr pull "git pull"
alias dot 'git --git-dir=$HOME/.dot --work-tree=$HOME'
abbr tn "npx --no-install ts-node --transpile-only"
abbr tt "tn src/tt.ts"
abbr code "code-insiders"
abbr todo "ag --color-line-number '1;36' --color-path '1;36' --print-long-lines --silent '((//|#|<!--|;|/\*|^)\s*(TODO|FIXME|FIX|BUG|UGLY|HACK|NOTE|IDEA|REVIEW|DEBUG|OPTIMIZE)|^\s*- \[ \])'"
abbr ntop "ultra --monitor"

abbr helpme "bat ~/HELP.md"
abbr weather "curl -s wttr.in/Ghent | grep -v Follow"

# Github Completions
gh completion -s fish | source

# Navi
navi widget fish | source

# Update
function update -d "Update homebrew, fish, pnpm"
  echo "[update] homebrew"
  brew update
  brew upgrade
  brew cleanup

  echo "[update] nodejs"
  pnpm update -g

  echo "[update] tldr"
  tldr -u

  echo "[update] fish"
  fisher self-update
  fisher
  fish_update_completions
end

abbr system "neofetch --source Downloads/cyberpunk.jpg"

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

abbr show-cursor "tput cnorm"
abbr hide-cursor "tput civis"

set -g fish_emoji_width 2

# Dracula Theme
if test -e ~/.config/fish/functions/dracula.fish
  builtin source ~/.config/fish/functions/dracula.fish
end

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true

starship init fish | source
