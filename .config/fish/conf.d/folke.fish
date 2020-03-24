# Bat Configuration
set -x BAT_THEME "Dracula"
set -x  MANPAGER "sh -c 'col -bx | bat -l man -p'" # use bat to format man pages

# Path
set -x PATH $PATH /usr/local/opt/ruby/bin /usr/local/lib/ruby/gems/2.6.0/bin
set -x PATH $PATH /Users/folke/go/bin

# Tmux
alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'
alias mux='tmuxinator'

# Changing Directories
alias ls="gls --group-directories-first --color=always"
alias grep='grep --color'
alias la='exa --all --icons --group-directories-first'
alias ll='exa --all --icons --group-directories-first --long'
alias l='ll'

# Editor
alias vim='nvim'
alias vi='nvim'
set -x EDITOR nvim

# Dev
alias git='hub'
alias g='git'
alias gl='g l --color | devmoji --log --color | less -rXF'
alias dot='git --git-dir=$HOME/.dot --work-tree=$HOME'
alias tn="npx --no-install ts-node --transpile-only"
alias tt="tn src/tt.ts"
alias code="code-insiders"
alias todo="ag --color-line-number '1;36' --color-path '1;36' --print-long-lines --silent '((//|#|<!--|;|/\*|^)\s*(TODO|FIXME|FIX|BUG|UGLY|HACK|NOTE|IDEA|REVIEW|DEBUG|OPTIMIZE)|^\s*- \[ \])'"
alias ntop="htop --tree -p (pgrep -d, node)"

# Update
alias update-fish="fisher self-update && fisher && fish_update_completions"
alias update-brew="brew update && brew upgrade"
alias update-node="pnpm update -g"
alias update="update-node && update-brew && update-fish"

function helpme
  bat ~/HELP.md
end