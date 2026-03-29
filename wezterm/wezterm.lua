local wezterm = require("wezterm")
local keys = require("keys")
local appearance = require("appearance")
local events = require("events")
local utils = require("utils")

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.automatically_reload_config = true

-- フォント設定
config.font = wezterm.font("JetBrains Mono", { weight = "Regular" })
config.font_size = 10.5
config.line_height = 0.88
config.freetype_load_flags = "DEFAULT"
config.freetype_load_target = "Normal"
config.freetype_render_target = "Normal"
config.front_end = "OpenGL"

-- ウィンドウ設定
config.initial_cols = 160
config.initial_rows = 45
config.text_background_opacity = 0.92
config.window_background_opacity = 0.92
config.use_ime = true

-- Leaderキー設定
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

appearance.setup(config)
keys.setup(config)
events.setup()

-- WSL起動 (Windowsのみ)
if utils.is_windows then
    config.default_prog = { "wsl.exe", "--cd", "~" }
end

return config
