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
			font = wt.font("VictorMono Nerd Font", { weight = "Light", style = "Italic" }),
		},
		{
			italic = true,
			intensity = "Bold",
			font = wt.font("VictorMono Nerd Font", { weight = "Bold", style = "Italic" }),
		},
	},
	color_scheme_dirs = { "/home/folke/projects/tokyonight.nvim/extras/wezterm" },
	color_scheme = "tokyonight_storm",
}
