set -q FZF_TMUX_HEIGHT; or set -U FZF_TMUX_HEIGHT "40%"
set -q FZF_DEFAULT_OPTS; or set -U FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT"
set -q FZF_LEGACY_KEYBINDINGS; or set -U FZF_LEGACY_KEYBINDINGS 1
set -q FZF_DISABLE_KEYBINDINGS; or set -U FZF_DISABLE_KEYBINDINGS 0
set -q FZF_PREVIEW_FILE_CMD; or set -U FZF_PREVIEW_FILE_CMD "head -n 10"
set -q FZF_PREVIEW_DIR_CMD; or set -U FZF_PREVIEW_DIR_CMD "ls"

function fzf_uninstall -e fzf_uninstall
    # disabled until we figure out a sensible way to ensure user overrides
    # are not erased
    # set -l _vars (set | command grep -E "^FZF.*\$" | command awk '{print $1;}')
    # for var in $_vars
    #     eval (set -e $var)
    # end
end
