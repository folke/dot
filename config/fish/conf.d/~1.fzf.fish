bind -M insert \ch __fzf_tldr

source ~/projects/tokyonight.nvim/extras/fzf/tokyonight_moon.sh

set -x FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS 
  --cycle
  --layout=reverse
  --height 60%
  --ansi
  --preview-window=right:70%
  --bind=ctrl-u:half-page-up,ctrl-d:half-page-down,ctrl-x:jump
  --bind=ctrl-f:preview-page-down,ctrl-b:preview-page-up
  --bind=ctrl-a:beginning-of-line,ctrl-e:end-of-line
  --bind=ctrl-j:down,ctrl-k:up
"

set fzf_diff_highlighter delta --paging=never --width=20
fzf_configure_bindings \
    --directory=\ct \
    --git_log=\cg \
    --git_status=\cs \
    --history= \
    --processes=\cp \
    --variables=
