local npairs = require("nvim-autopairs")

npairs.setup()

-- skip it, if you use another global object
_G.MUtils = {}

vim.g.completion_confirm_key = ""

MUtils.completion_confirm = function(keys)
  if vim.fn.pumvisible() ~= 0 then
    return vim.fn["compe#confirm"]({ keys = keys, select = true })
  else
    if keys == "<cr>" then
      return npairs.check_break_line_char()
    else
      return npairs.esc(keys)
    end
  end
end

require("util").inoremap("<CR>", [[v:lua.MUtils.completion_confirm("<cr>")]], { expr = true })
require("util").inoremap("<Tab>", [[v:lua.MUtils.completion_confirm("<tab>")]], { expr = true })

