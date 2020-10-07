##
#### Added by Zinit's installer
#if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
#    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
#    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
#    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
#        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
#        print -P "%F{160}▓▒░ The clone has failed.%f%b"
#fi
#
#source "$HOME/.zinit/bin/zinit.zsh"
#autoload -Uz _zinit
#(( ${+_comps} )) && _comps[zinit]=_zinit
#
#### End of Zinit's installer chunk
#
#export PURE_PROMPT_SYMBOL="☯︎"
#
#zinit ice blockf atpull'zinit creinstall -q .'
#zinit light zsh-users/zsh-completions
#
#autoload compinit
#compinit
#
#zinit light zdharma/fast-syntax-highlighting
#zinit light zsh-users/zsh-autosuggestions
#
#zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
#zinit light sindresorhus/pure
eval "$(starship init zsh)"
