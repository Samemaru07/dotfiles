local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

local utils = require("utils")
local is_windows = utils.is_windows

local keys = require("keys")

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

-- 背景設定
local bg_path

if is_windows then
    -- Windows版 WezTerm → WSL 内 dotfiles を参照
    -- wezterm.home_dir は "C:\Users\<WindowsUser>" 形式。WSLユーザー名が異なる場合は
    -- 環境変数 WSL_USER を設定してください (例: setx WSL_USER "yourname")
    local wsl_user = os.getenv("WSL_USER") or wezterm.home_dir:match("Users\\(.+)$") or "ubuntu"
    bg_path = "\\\\wsl$\\Ubuntu\\home\\" .. wsl_user .. "\\dotfiles\\assets\\terminal\\hala.png"
else
    -- Arch Linux / Linux版 WezTerm
    bg_path = (os.getenv("HOME") or wezterm.home_dir) .. "/dotfiles/assets/terminal/hala.png"
end

config.background = {
    {
        source = {
            File = bg_path,
        },
        hsb = { brightness = 0.18, saturation = 0.9 },
        attachment = "Fixed",
    },
    {
        source = { Color = "rgba(0,0,0,0.25)" },
        width = "100%",
        height = "100%",
    },
}

-- 外観設定
config.window_decorations = "RESIZE"
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.show_new_tab_button_in_tab_bar = false
config.inactive_pane_hsb = {
    saturation = 0.85,
    brightness = 0.5,
}

config.colors = {
    foreground = "#F0E4D6",
    background = "#181614",

    cursor_bg = "#4A7BD1",
    cursor_fg = "#181614",
    cursor_border = "#4A7BD1",

    selection_bg = "#3A332E",
    selection_fg = "#F0E4D6",

    ansi = {
        "#181614",
        "#C4746E",
        "#8DAA7F",
        "#D0B27A",
        "#4A7BD1",
        "#A58CC4",
        "#7FAFA9",
        "#E6D8C9",
    },

    brights = {
        "#9E9E9E",
        "#E08A84",
        "#A7C29A",
        "#E5C98F",
        "#6C9BFF",
        "#C2A6E0",
        "#9ED0C9",
        "#FFF3E6",
    },

    tab_bar = {
        background = "rgba(0,0,0,0)",

        active_tab = {
            bg_color = "#ae8b2d",
            fg_color = "#FFFFFF",
        },

        inactive_tab = {
            bg_color = "rgba(0,0,0,0)",
            fg_color = "#CBBBAA",
        },

        inactive_tab_hover = {
            bg_color = "rgba(0,0,0,0)",
            fg_color = "#F0E4D6",
        },

        new_tab = {
            bg_color = "rgba(0,0,0,0)",
            fg_color = "#CBBBAA",
        },
    },
}

-- 現在のモードの状態を表示
wezterm.on("update-right-status", function(window, pane)
    local status = ""
    local bg_color = "#ae8b2d"
    local name = window:active_key_table()

    if name == "resize_pane" then
        status = "   RESIZE   "
        bg_color = "#4fad2d"
    elseif name == "copy_mode" then
        status = "  COPY  "
        bg_color = "#2d4fad"
    elseif name == "pane_selection" then
        status = " PANE SELECT "
        bg_color = "#ad2d8f"
    elseif window:leader_is_active() then
        status = "   LEADER   "
        bg_color = "#ae8b2d"
    end

    if status ~= "" then
        window:set_right_status(wezterm.format({
            { Attribute = { Intensity = "Bold" } },
            { Background = { Color = bg_color } },
            { Foreground = { Color = "#FFFFFF" } },
            { Text = status },
        }))
    else
        window:set_right_status("")
    end
end)

local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local background = "#5c6d74"
    local foreground = "#FFFFFF"
    local edge_background = "none"

    if tab.is_active then
        background = "#ae8b2d"
        foreground = "#FFFFFF"
    end

    local edge_foreground = background
    local title = tab.tab_title

    -- 追加: コピーモード等で自動的に設定されるタイトルが含まれる場合は無視する
    if title and title:find("Copy mode") then
        title = nil
    end

    if not title or #title == 0 then
        title = "\xEE\xAA\x85 zsh"
    end
    title = " " .. wezterm.truncate_right(title, max_width - 1) .. " "

    local items = {}

    if tab.tab_index == 0 then
        table.insert(items, { Background = { Color = "none" } })
        table.insert(items, { Text = "   " })
    end

    table.insert(items, { Background = { Color = edge_background } })
    table.insert(items, { Foreground = { Color = edge_foreground } })
    table.insert(items, { Text = SOLID_LEFT_ARROW })
    table.insert(items, { Background = { Color = background } })
    table.insert(items, { Foreground = { Color = foreground } })
    table.insert(items, { Text = title })
    table.insert(items, { Background = { Color = edge_background } })
    table.insert(items, { Foreground = { Color = edge_foreground } })
    table.insert(items, { Text = SOLID_RIGHT_ARROW })
    table.insert(items, { Text = "  " })

    return items
end)

config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 500

-- Leader設定 Ctrl + q (待機時間 2000ms)
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

keys.setup(config)

config.enable_wayland = false

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
    local title = tab.tab_title
    if title and #title > 0 then
        return title
    end
    return tab.active_pane.title
end)

return config
