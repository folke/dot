local M = {
  event = "User PackerDefered",
  requires = { "kkharji/sqlite.lua", module = "sqlite" },
}

---@alias YankyType 'p'|'P'|'gp'|'gP'|'[p'|']p'
---@alias YankyChange boolean|'>'|'<'|'='

---@param type YankyType
---@param is_visual boolean
---@param linewise YankyChange
function M.put(type, is_visual, linewise)
  local yanky_wrappers = require("yanky.wrappers")
  local yanky = require("yanky")
  local callback = linewise == true and yanky_wrappers.linewise()
    or type(linewise) == "string" and yanky_wrappers.linewise(yanky_wrappers.change(linewise))
  yanky.put(type, is_visual, callback)
end

function M.init()
  vim.keymap.set("n", "<leader>P", function()
    require("telescope").extensions.yank_history.yank_history({})
  end, { desc = "Paste from Yanky" })
end

function M.config()
  require("yanky").setup({
    highlight = {
      timer = 150,
    },
    ring = {
      storage = "sqlite",
    },
  })

  vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)")

  vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
  vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
  vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
  vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

  vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
  vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")

  -- vim.keymap.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)")
  -- vim.keymap.set("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)")
  -- vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)")
  -- vim.keymap.set("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)")
  --
  -- vim.keymap.set("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)")
  -- vim.keymap.set("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)")
  -- vim.keymap.set("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)")
  -- vim.keymap.set("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)")

  vim.keymap.set("n", "]p", "<Plug>(YankyPutAfterFilter)")
  vim.keymap.set("n", "[p", "<Plug>(YankyPutBeforeFilter)")
end

return M
