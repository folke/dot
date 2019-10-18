if [[ "$ZPROF" = true ]]; then
    zmodload zsh/zprof
fi

# Load zplugin
source ~/.zplugin/bin/zplugin.zsh

zplugin light denysdovhan/spaceship-prompt

zplugin ice wait lucid blockf atpull'zplugin creinstall -q .'
zplugin light zsh-users/zsh-completions

zplugin ice wait lucid atload"_zsh_autosuggest_start"
zplugin light zsh-users/zsh-autosuggestions

export NVM_LAZY_LOAD=true
zplugin ice wait"1" lucid
zplugin light lukechilds/zsh-nvm

zplugin ice wait lucid
zplugin snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh

zplugin ice atclone"gdircolors -b LS_COLORS > c.zsh" atpull'%atclone' pick"c.zsh" nocompile'!'
zplugin light trapd00r/LS_COLORS

# diff-so-fancy
zplugin ice wait"2" lucid as"program" pick"bin/git-dsf"
zplugin load zdharma/zsh-diff-so-fancy

# Semigraphical interface to zplugin
zplugin light "zdharma/zui"
zplugin light "zdharma/zplugin-crasis"

# Load system completions
zplugin ice wait lucid atclone"print Installing completions...; \
    zplugin creinstall -q /usr/local/share/zsh/site-functions;
    zplugin creinstall -q /usr/local/Cellar/zsh/*/share/zsh/functions" \
    atpull"%atclone" id-as"system-completions"
zplugin snippet /dev/null

zplugin ice wait lucid atinit"zpcompinit; zpcdreplay"
zplugin light zdharma/fast-syntax-highlighting

# User configuration

## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data


# Changing directories
setopt auto_cd
setopt auto_pushd
unsetopt pushd_ignore_dups
setopt pushdminus

# Completion
setopt auto_menu
setopt always_to_end
setopt correct
setopt complete_in_word
unsetopt complete_aliases
unsetopt flow_control
unsetopt menu_complete
zstyle ':completion:*:*:*:*:*' menu select=0
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

alias dot='git --git-dir=$HOME/.dot --work-tree=$HOME'
alias git='hub'

source "/usr/local/opt/fzf/shell/key-bindings.zsh"
export FZF_DEFAULT_OPTS="--ansi --height=70%"
export FZF_CTRL_T_COMMAND='fd --ignore-file ~/.gitignore --type f --color=always --hidden --follow --exclude .git'
export FZF_CTRL_T_OPTS="--preview-window 'right:60%' --preview 'bat --color=always --line-range :300 {}'"
export FZF_ALT_C_COMMAND='fd --ignore-file ~/.gitignore --type d --color=always --hidden --follow --exclude .git'

export PATH="/usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/2.6.0/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

alias ls="gls --group-directories-first --color=always"
alias grep='grep --color'
alias l='exa --all --icons --group-directories-first'
alias ll='exa --all --icons --group-directories-first --long'
alias vim='nvim'
alias vi='nvim'

alias update-zsh="zplugin self-update && zplugin update"
alias update-brew="brew update && brew upgrade"
alias update-all="update-brew && update-zsh"

unsetopt PROMPT_SP # Fix the annoying % character showing up in first tab on load

if [[ "$ZPROF" = true ]]; then
  zprof
fi

function zprofile {
  timer=$(($(gdate +%s%N)/1000000)) 
  ZPROF=true /usr/local/bin/zsh -i -c exit
  now=$(($(gdate +%s%N)/1000000))
  elapsed=$(($now-$timer))
  echo "Zsh loaded in ${elapsed}ms"
}
