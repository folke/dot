local wt = require("wezterm")

return {
	font_size = 12,
	font = wt.font("FiraCode Nerd Font"),
	font_rules = {
		{
			intensity = "Bold",
			font = wt.font("FiraCode Nerd Font", { weight = "Bold" }),
		},
		{
			italic = true,
			font = wt.font("VictorMono Nerd Font", { weight = "DemiLight" }),
		},
		{
			italic = true,
			intensity = "Bold",
			font = wt.font("VictorMono Nerd Font", { weight = "DemiBold" }),
		},
	},
	color_scheme_dirs = { "/Users/folke/projects/tokyonight.nvim/extras/wezterm" },
	color_scheme = "tokyonight_storm",
}
