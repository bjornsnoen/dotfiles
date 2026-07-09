local wezterm = require("wezterm") ---@type Wezterm
local config = wezterm.config_builder() ---@type Config

-- Appearance

config.font_size = 12
config.color_scheme = "Dracula"
config.cursor_blink_rate = 500
config.font = wezterm.font_with_fallback({
	"Fira Code",
	"SauceCodePro NFM",
})
config.audible_bell = "Disabled"

-- Behavior

config.default_prog = { "wsl.exe", "~" }
config.keys = {
	{
		key = "P",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SpawnCommandInNewTab({
			args = { "pwsh.exe" },
		}),
	},
	{
		key = "R",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ReloadConfiguration,
	},
	{
		key = "M",
		mods = "CTRL|SHIFT",
		action = wezterm.action.DisableDefaultAssignment,
	},
}

return config
