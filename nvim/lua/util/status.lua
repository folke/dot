local M = {}
_G.Status = M

---@return {name:string, text:string, texthl:string}[]
function M.get_signs(win)
  local buf = vim.api.nvim_win_get_buf(win)
  return vim.tbl_map(function(sign)
    return vim.fn.sign_getdefined(sign.name)[1]
  end, vim.fn.sign_getplaced(buf, { group = "*", lnum = vim.v.lnum })[1].signs)
end

function M.column()
  local win = vim.g.statusline_winid
  local sign, git_sign
  for _, s in ipairs(M.get_signs(win)) do
    if s.name:find("GitSign") then
      git_sign = s
    else
      sign = s
    end
  end

  local nu = " "
  if vim.wo[win].number and vim.wo[win].relativenumber and vim.v.virtnum == 0 then
    nu = vim.v.relnum == 0 and vim.v.lnum or vim.v.relnum
  end
  local components = {
    sign and ("%#" .. (sign.texthl or "DiagnosticInfo") .. "#" .. sign.text .. "%*") or "  ",
    [[%=]],
    nu .. " ",
    git_sign and ("%#" .. git_sign.texthl .. "#" .. git_sign.text .. "%*") or "  ",
  }
  return table.concat(components, "")
end

if vim.fn.has("nvim-0.9.0") == 1 then
  vim.opt.statuscolumn = [[%!v:lua.Status.column()]]
end

return M
