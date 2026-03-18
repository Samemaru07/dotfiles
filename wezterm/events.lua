local wezterm = require("wezterm")

local M = {}

M.setup = function()
    local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
    local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

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

    wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
        local title = tab.tab_title
        if title and #title > 0 then
            return title
        end
        return tab.active_pane.title
    end)
end

return M
