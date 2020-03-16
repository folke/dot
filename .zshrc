if [[ "$ZPROF" == true ]]; then
    zmodload zsh/zprof
fi

# Load zinit
source ~/.zinit/bin/zinit.zsh

zinit ice wait lucid blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

zinit ice wait lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

export NVM_LAZY_LOAD=true
# export NVM_NO_USE=true
export NVM_AUTO_USE=true
zinit ice wait"!0" lucid
zinit light lukechilds/zsh-nvm

# Use vivid to generate colors to be used by ls and exa
zinit ice atclone" \
    VIVID=\$(vivid*/vivid -d vivid*/share/vivid/filetypes.yml generate vivid*/share/vivid/themes/snazzy.yml); \
    echo export LS_COLORS=\\\"\$VIVID\\\" > c.zsh;" \
    atpull'%atclone' from"gh-r" pick"c.zsh" nocompile'!'
zinit light sharkdp/vivid

# Load system completions
zinit ice wait lucid atclone"print Installing completions...; \
    zinit creinstall -q /usr/local/share/zsh/site-functions; \
    zinit creinstall -q /usr/local/Cellar/zsh/*/share/zsh/functions" \
    atpull"%atclone" id-as"system-completions"
zinit snippet /dev/null


# OMZ Completions
zinit ice svn pick"completion.zsh" src"git.zsh"
zinit snippet OMZ::lib

# z.lua
zinit ice wait lucid atinit"zicompinit; zicdreplay"
zinit light skywind3000/z.lua

zinit ice wait lucid atinit"zicompinit; zicdreplay"
zinit light zdharma/fast-syntax-highlighting

eval "$(starship init zsh)"

autoload -Uz compinit
compinit
zinit cdreplay -q

# User configuration

## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_all_dups   # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data
setopt hist_find_no_dups
setopt hist_save_no_dups

# Changing directories
setopt auto_cd
setopt auto_pushd
unsetopt pushd_ignore_dups
setopt pushdminus

# Title
precmd () {print -Pn "\e]0;%2~\a"}
preexec () {print -Pn "\e]0;%2~\a"}

# Fuzzy Finder
source "/usr/local/opt/fzf/shell/key-bindings.zsh"
export FZF_DEFAULT_OPTS="--ansi --height=70%"
export FZF_CTRL_T_COMMAND='fd --ignore-file ~/.gitignore --type f --color=always --hidden --follow --exclude .git'
export FZF_CTRL_T_OPTS="--preview-window 'right:60%' --preview 'bat --color=always --line-range :300 {}'"
export FZF_ALT_C_COMMAND='fd --ignore-file ~/.gitignore --type d --color=always --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=dark
--color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
--color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
'

# bat configuration
export BAT_THEME="Dracula"
export MANPAGER="sh -c 'col -bx | bat -l man -p'" # use bat to format man pages

# Path
export PATH="/usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/2.6.0/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

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
export EDITOR=nvim

# Dev
alias git='hub'
alias g='git'
alias gl='g l --color | devmoji --log --color | less -rXF'
alias dot='git --git-dir=$HOME/.dot --work-tree=$HOME'
alias tn="npx --no-install ts-node --transpile-only"
alias code="code-insiders"
alias todo="ag --color-line-number '1;36' --color-path '1;36' --print-long-lines --silent '((//|#|<!--|;|/\*|^)\s*(TODO|FIXME|FIX|BUG|UGLY|HACK|NOTE|IDEA|REVIEW|DEBUG|OPTIMIZE)|^\s*- \[ \])'"
alias ntop="htop --tree -p \$(pgrep -d, node)"

# Update
alias update-zsh="zinit self-update && zinit update"
alias update-brew="brew update && brew upgrade"
alias update-all="update-brew && update-zsh"

function help() {
    if (($# == 0)); then
        bat ~/HELP.md
    else
        bat -H $(cat ~/HELP.md | grep -n "$1" | head -1 | cut -d : -f 1) ~/HELP.md
    fi
}

fuck() {
    TF_PYTHONIOENCODING=$PYTHONIOENCODING
    export TF_SHELL=zsh
    export TF_ALIAS=fuck
    TF_SHELL_ALIASES=$(alias)
    export TF_SHELL_ALIASES
    TF_HISTORY="$(fc -ln -10)"
    export TF_HISTORY
    export PYTHONIOENCODING=utf-8
    TF_CMD=$(
        thefuck THEFUCK_ARGUMENT_PLACEHOLDER $@
    ) && eval $TF_CMD
    unset TF_HISTORY
    export PYTHONIOENCODING=$TF_PYTHONIOENCODING
    test -n "$TF_CMD" && print -s $TF_CMD
}

#unsetopt PROMPT_SP # Fix the annoying % character showing up in first tab on load
setopt PROMPT_CR
setopt PROMPT_SP
export PROMPT_EOL_MARK=""

if [[ "$ZPROF" == true ]]; then
    zprof
fi

function zprofile() {
    timer=$(($(gdate +%s%N) / 1000000))
    ZPROF=true /usr/local/bin/zsh -i -c exit
    now=$(($(gdate +%s%N) / 1000000))
    elapsed=$(($now - $timer))
    echo "Zsh loaded in ${elapsed}ms"
}
