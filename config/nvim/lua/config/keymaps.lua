local wk = require("which-key")
local util = require("util")

vim.o.timeoutlen = 300

local id
for _, key in ipairs({ "h", "j", "k", "l" }) do
  local count = 0
  vim.keymap.set("n", key, function()
    if count >= 10 then
      id = vim.notify("Hold it Cowboy!", vim.log.levels.WARN, {
        icon = "🤠",
        replace = id,
        keep = function()
          return count >= 10
        end,
      })
    else
      count = count + 1
      vim.defer_fn(function()
        count = count - 1
      end, 5000)
      return key
    end
  end, { expr = true })
end

-- Move to window using the movement keys
vim.keymap.set("n", "<left>", "<C-w>h")
vim.keymap.set("n", "<down>", "<C-w>j")
vim.keymap.set("n", "<up>", "<C-w>k")
vim.keymap.set("n", "<right>", "<C-w>l")

-- change word with <c-c>
vim.keymap.set("n", "<C-c>", "<cmd>normal ciw<cr>a")

-- makes * and # work on visual mode too.
vim.cmd([[
  function! g:VSetSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
  endfunction

  xnoremap * :<C-u>call g:VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
  xnoremap # :<C-u>call g:VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
]])

local leader = {
  ["w"] = {
    name = "+windows",
    ["w"] = { "<C-W>p", "other-window" },
    ["d"] = { "<C-W>c", "delete-window" },
    ["-"] = { "<C-W>s", "split-window-below" },
    ["|"] = { "<C-W>v", "split-window-right" },
  },
  b = {
    name = "+buffer",
    ["b"] = { "<cmd>:e #<cr>", "Switch to Other Buffer" },
    ["p"] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
    ["["] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
    ["n"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
    ["]"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
    -- ["D"] = { "<cmd>:bd<CR>", "Delete Buffer & Window" },
  },
  g = {
    name = "+git",
    d = { "<cmd>DiffviewOpen<cr>", "DiffView" },
    h = { name = "+hunk" },
  },
  t = {
    name = "toggle",
    f = {
      require("lazyvim.plugins.lsp.format").toggle,
      "Format on Save",
    },
    s = {
      function()
        util.toggle("spell")
      end,
      "Spelling",
    },
    w = {
      function()
        util.toggle("wrap")
      end,
      "Word Wrap",
    },
    n = {
      function()
        util.toggle("relativenumber", true)
        util.toggle("number")
      end,
      "Line Numbers",
    },
  },
  ["<tab>"] = {
    name = "tabs",
    ["<tab>"] = { "<cmd>tabnew<CR>", "New Tab" },
    n = { "<cmd>tabnext<CR>", "Next" },
    d = { "<cmd>tabclose<CR>", "Close" },
    p = { "<cmd>tabprevious<CR>", "Previous" },
    ["]"] = { "<cmd>tabnext<CR>", "Next" },
    ["["] = { "<cmd>tabprevious<CR>", "Previous" },
    f = { "<cmd>tabfirst<CR>", "First" },
    l = { "<cmd>tablast<CR>", "Last" },
  },
  ["`"] = { "<cmd>:e #<cr>", "Switch to Other Buffer" },
  [" "] = "Find File",
  ["C"] = {
    function()
      util.clipman()
    end,
    "Paste from Clipman",
  },
  z = { [[<cmd>ZenMode<cr>]], "Zen Mode" },
  T = {
    function()
      util.test(true)
    end,
    "Plenary Test File",
  },
  D = {
    function()
      util.test()
    end,
    "Plenary Test Directory",
  },
}

for i = 0, 10 do
  leader[tostring(i)] = "which_key_ignore"
end

wk.register(leader, { prefix = "<leader>" })

wk.register({ g = { name = "+goto" } })
