
function projects
  set myprojects which-key.nvim persistence.nvim workspace.nvim tokyonight.nvim trouble.nvim zen-mode.nvim lsp-colors.nvim todo-comments.nvim lua-dev.nvim twilight.nvim

  for p in $myprojects
    set fp ~/projects/$p
    if test ! -d $fp
      echo "[clone] $fp"
      git clone git@github.com:folke/$p.git $fp
    end
  end
end
