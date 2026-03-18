local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

local keys = require("keys")

local appearance = require("appearance")

local events = require("events")

config.automatically_reload_config = true

-- 基本設定
config.font_size = 10.5
config.initial_cols = 160
config.initial_rows = 45
config.freetype_load_flags = "DEFAULT"
config.freetype_load_target = "Normal"
config.freetype_render_target = "Normal"
config.front_end = "OpenGL"
config.text_background_opacity = 0.92
config.window_background_opacity = 0.92
config.font = wezterm.font("JetBrains Mono", { weight = "Regular" })
config.line_height = 0.98
config.use_ime = true

-- Leader設定 Ctrl + q (待機時間 2000ms)
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

keys.setup(config)
appearance.setup(config)
events.setup()

return config
