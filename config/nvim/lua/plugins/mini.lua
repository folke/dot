return {
  -- better text objects
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    config = function(plugin)
      -- call config of parent spec
      plugin._.super.config()

      -- add treesitter jumping
      local function jump(capture, start, down)
        return function()
          local parser = vim.treesitter.get_parser()
          if not parser then
            return vim.notify("No treesitter parser for the current buffer", vim.log.levels.ERROR)
          end

          local query = vim.treesitter.get_query(vim.bo.filetype, "textobjects")
          if not query then
            return vim.notify("No textobjects query for the current buffer", vim.log.levels.ERROR)
          end

          local cursor = vim.api.nvim_win_get_cursor(0)

          ---@type {[1]:number, [2]:number}[]
          local locs = {}
          for _, tree in ipairs(parser:trees()) do
            for capture_id, node, _ in query:iter_captures(tree:root(), 0) do
              if query.captures[capture_id] == capture then
                local range = { node:range() } ---@type number[]
                local row = (start and range[1] or range[3]) + 1
                local col = (start and range[2] or range[4]) + 1
                if down and row > cursor[1] or (not down) and row < cursor[1] then
                  table.insert(locs, { row, col })
                end
              end
            end
          end
          return pcall(vim.api.nvim_win_set_cursor, 0, down and locs[1] or locs[#locs])
        end
      end
      vim.keymap.set("n", "[f", jump("function.outer", true, false))
      vim.keymap.set("n", "]f", jump("function.outer", true, true))
      vim.keymap.set("n", "[F", jump("function.outer", false, false))
      vim.keymap.set("n", "]F", jump("function.outer", false, true))
      vim.keymap.set("n", "[c", jump("class.outer", true, false))
      vim.keymap.set("n", "]c", jump("class.outer", true, true))
      vim.keymap.set("n", "[C", jump("class.outer", false, false))
      vim.keymap.set("n", "]C", jump("class.outer", false, true))
    end,
  },

  -- animations
  {
    "echasnovski/mini.animate",
    config = function()
      local mouse_scrolled = false
      for _, scroll in ipairs({ "Up", "Down" }) do
        local key = "<ScrollWheel" .. scroll .. ">"
        vim.keymap.set("", key, function()
          mouse_scrolled = true
          return key
        end, { expr = true })
      end

      local animate = require("mini.animate")
      vim.go.winwidth = 20
      vim.go.winminwidth = 5

      animate.setup({
        resize = {
          timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
        },
        scroll = {
          timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
          subscroll = animate.gen_subscroll.equal({
            predicate = function(total_scroll)
              if mouse_scrolled then
                mouse_scrolled = false
                return false
              end
              return total_scroll > 1
            end,
          }),
        },
      })
    end,
  },
}
