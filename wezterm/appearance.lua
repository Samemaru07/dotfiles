local wezterm = require("wezterm")
local utils = require("utils")
local is_windows = utils.is_windows

local M = {}

M.setup = function(config)
    -- 背景設定
    local bg_path

    if is_windows then
        bg_path = "\\\\wsl$\\Ubuntu\\home\\samemaru\\dotfiles\\assets\\terminal\\seri.jpg"
    else
        bg_path = wezterm.home_dir .. "/dotfiles/assets/terminal/hala.png"
    end

    config.background = {
        {
            source = { File = bg_path },
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
    config.tab_max_width = 60
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

    -- カーソル設定
    config.default_cursor_style = "BlinkingBlock"
    config.cursor_blink_rate = 500

    if not is_windows then
        config.xcursor_theme = "FernCursor"
        config.xcursor_size = 24
    end

    config.enable_wayland = false
end

return M
