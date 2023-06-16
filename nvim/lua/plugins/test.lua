return {
  { "nvim-neotest/neotest-plenary" },
  { "marilari88/neotest-vitest" },
  {
    "nvim-neotest/neotest",
    opts = { adapters = { ["neotest-plenary"] = {
      min_init = "./tests/init.lua",
    }, "neotest-vitest" } },
  },
}
