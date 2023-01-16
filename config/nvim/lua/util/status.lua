local M = {}
_G.Status = M

function M.fold()
  local line = vim.v.lnum
  -- if vim.fn.foldlevel(line) > 1 then
  -- 	return " "
  -- end

  if vim.fn.foldlevel(line) <= vim.fn.foldlevel(line - 1) then
    return " "
  end

  return vim.fn.foldclosed(line) > 0 and "" or ""
end

function M.status_column()
  local components = {
    [[%=]],
    [[%{&nu?(&rnu&&v:relnum?v:relnum:v:lnum):''}]],
    [[ %s]],
    -- [[%#FoldColumn#%{v:lua.Status.fold()} ]],
  }
  return table.concat(components, "")
end

vim.opt.statuscolumn = M.status_column()

return M
