local wezterm = require("wezterm")
local utils = require("utils")
local is_windows = utils.is_windows
local get_cwd_path = utils.get_cwd_path

local M = {}

M.setup = function(config)
    config.keys = {
        -- 縦分割(左右に2枚)
        {
            key = "%",
            mods = "LEADER|SHIFT",
            action = wezterm.action_callback(function(window, pane)
                local cwd = get_cwd_path(pane)
                local split_opts = { direction = "Right" }
                if is_windows then
                    local args = { "wsl.exe", "-d", "Ubuntu" }
                    if cwd then
                        args = { "wsl.exe", "-d", "Ubuntu", "-e", "bash", "-c", "cd '" .. cwd .. "'; exec zsh" }
                    end
                    split_opts.args = args
                elseif cwd then
                    split_opts.cwd = cwd
                end
                pane:split(split_opts)
            end),
        },

        -- 横分割(上下に2枚)
        {
            key = '"',
            mods = "LEADER|SHIFT",
            action = wezterm.action_callback(function(window, pane)
                local cwd = get_cwd_path(pane)
                local split_opts = { direction = "Bottom" }
                if is_windows then
                    local args = { "wsl.exe", "-d", "Ubuntu" }
                    if cwd then
                        args = { "wsl.exe", "-d", "Ubuntu", "-e", "bash", "-c", "cd '" .. cwd .. "'; exec zsh" }
                    end
                    split_opts.args = args
                elseif cwd then
                    split_opts.cwd = cwd
                end
                pane:split(split_opts)
            end),
        },

        -- ペイン移動
        {
            key = "LeftArrow",
            mods = "LEADER",
            action = wezterm.action.ActivatePaneDirection("Left"),
        },
        {
            key = "RightArrow",
            mods = "LEADER",
            action = wezterm.action.ActivatePaneDirection("Right"),
        },
        {
            key = "DownArrow",
            mods = "LEADER",
            action = wezterm.action.ActivatePaneDirection("Down"),
        },
        {
            key = "UpArrow",
            mods = "LEADER",
            action = wezterm.action.ActivatePaneDirection("Up"),
        },

        -- リサイズ
        {
            key = "z",
            mods = "LEADER",
            action = wezterm.action.ActivateKeyTable({
                name = "resize_pane",
                one_shot = false,
            }),
        },

        -- ペイン削除
        {
            key = "x",
            mods = "LEADER",
            action = wezterm.action.CloseCurrentPane({ confirm = true }),
        },

        -- タブ名変更
        {
            key = "r",
            mods = "LEADER",
            action = wezterm.action.PromptInputLine({
                description = "新しいタブ名を入力してください",
                action = wezterm.action_callback(function(window, pane, line)
                    if line then
                        window:active_tab():set_title("\xEE\xAA\x85 " .. line)
                    end
                end),
            }),
        },

        -- 画面フルスクリーン切り替え
        {
            key = "Enter",
            mods = "ALT",
            action = wezterm.action.ToggleFullScreen,
        },

        -- コピーモード
        {
            key = "[",
            mods = "LEADER",
            action = wezterm.action.ActivateCopyMode,
        },

        -- ペイン移動モード
        {
            key = "m",
            mods = "LEADER",
            action = wezterm.action.ActivateKeyTable({
                name = "pane_selection",
                one_shot = false,
            }),
        },

        -- ペースト
        {
            key = "v",
            mods = "CTRL",
            action = wezterm.action.PasteFrom("Clipboard"),
        },

        -- フォントサイズ切り替え
        {
            key = ";",
            mods = "CTRL",
            action = wezterm.action.IncreaseFontSize,
        },
        {
            key = "-",
            mods = "CTRL",
            action = wezterm.action.DecreaseFontSize,
        },
        {
            key = "0",
            mods = "CTRL",
            action = wezterm.action.ResetFontSize,
        },

        -- タブ切り替え
        {
            key = "1",
            mods = "LEADER",
            action = wezterm.action.ActivateTab(0),
        },
        {
            key = "2",
            mods = "LEADER",
            action = wezterm.action.ActivateTab(1),
        },
        {
            key = "3",
            mods = "LEADER",
            action = wezterm.action.ActivateTab(2),
        },
        {
            key = "4",
            mods = "LEADER",
            action = wezterm.action.ActivateTab(3),
        },
        {
            key = "5",
            mods = "LEADER",
            action = wezterm.action.ActivateTab(4),
        },
        {
            key = "6",
            mods = "LEADER",
            action = wezterm.action.ActivateTab(5),
        },
        {
            key = "7",
            mods = "LEADER",
            action = wezterm.action.ActivateTab(6),
        },
        {
            key = "8",
            mods = "LEADER",
            action = wezterm.action.ActivateTab(7),
        },
        {
            key = "9",
            mods = "LEADER",
            action = wezterm.action.ActivateTab(-1),
        },

        -- 右のタブへ移動
        {
            key = "RightArrow",
            mods = "LEADER",
            action = wezterm.action.ActivateTabRelative(1),
        },
        -- 左のタブへ移動
        {
            key = "LeftArrow",
            mods = "LEADER",
            action = wezterm.action.ActivateTabRelative(-1),
        },

        -- コマンドパレット
        {
            key = "p",
            mods = "LEADER",
            action = wezterm.action.ActivateCommandPalette,
        },

        -- lazygitを新しいウィンドウで開く
        {
            key = "g",
            mods = "LEADER",
            action = wezterm.action_callback(function(window, pane)
                local cwd = get_cwd_path(pane)
                local cmd = (cwd and ("cd '" .. cwd .. "' && ") or "") .. "lazygit || read"
                local args
                if is_windows then
                    args = { "wsl.exe", "-d", "Ubuntu", "-e", "bash", "-c", cmd }
                else
                    args = { "bash", "-c", cmd }
                end
                window:perform_action(wezterm.action.SpawnCommandInNewWindow({ args = args }), pane)
            end),
        },
    }

    -- PowerShellを新しいタブで開く (Windowsのみ)
    if is_windows then
        table.insert(config.keys, {
            key = "p",
            mods = "CTRL|SHIFT",
            action = wezterm.action_callback(function(window, pane)
                local new_tab = window:mux_window():spawn_tab({
                    args = { "powershell.exe" },
                })
                new_tab:set_title("PowerShell")
            end),
        })
    end

    config.key_tables = {
        resize_pane = {
            { key = "h", action = wezterm.action.AdjustPaneSize({ "Left", 1 }) },
            { key = "l", action = wezterm.action.AdjustPaneSize({ "Right", 1 }) },
            { key = "k", action = wezterm.action.AdjustPaneSize({ "Up", 1 }) },
            { key = "j", action = wezterm.action.AdjustPaneSize({ "Down", 1 }) },
            { key = "Escape", action = "PopKeyTable" },
            { key = "Enter", action = "PopKeyTable" },
        },

        pane_selection = {
            { key = "h", action = wezterm.action.ActivatePaneDirection("Left") },
            { key = "j", action = wezterm.action.ActivatePaneDirection("Down") },
            { key = "k", action = wezterm.action.ActivatePaneDirection("Up") },
            { key = "l", action = wezterm.action.ActivatePaneDirection("Right") },
            { key = "Escape", action = "PopKeyTable" },
            { key = "Enter", action = "PopKeyTable" },
        },

        copy_mode = {
            -- 移動
            { key = "h", mods = "NONE", action = wezterm.action.CopyMode("MoveLeft") },
            { key = "j", mods = "NONE", action = wezterm.action.CopyMode("MoveDown") },
            { key = "k", mods = "NONE", action = wezterm.action.CopyMode("MoveUp") },
            { key = "l", mods = "NONE", action = wezterm.action.CopyMode("MoveRight") },
            -- 最初と最後に移動
            { key = "^", mods = "NONE", action = wezterm.action.CopyMode("MoveToStartOfLineContent") },
            { key = "$", mods = "SHIFT", action = wezterm.action.CopyMode("MoveToEndOfLineContent") },
            -- 左端に移動
            { key = "0", mods = "NONE", action = wezterm.action.CopyMode("MoveToStartOfLine") },
            { key = "o", mods = "NONE", action = wezterm.action.CopyMode("MoveToSelectionOtherEnd") },
            { key = "O", mods = "NONE", action = wezterm.action.CopyMode("MoveToSelectionOtherEndHoriz") },
            --
            { key = ";", mods = "NONE", action = wezterm.action.CopyMode("JumpAgain") },
            -- 単語ごと移動
            { key = "w", mods = "NONE", action = wezterm.action.CopyMode("MoveForwardWord") },
            { key = "b", mods = "NONE", action = wezterm.action.CopyMode("MoveBackwardWord") },
            { key = "e", mods = "NONE", action = wezterm.action.CopyMode("MoveForwardWordEnd") },
            -- ジャンプ機能 t f
            { key = "t", mods = "NONE", action = wezterm.action.CopyMode({ JumpForward = { prev_char = true } }) },
            { key = "f", mods = "NONE", action = wezterm.action.CopyMode({ JumpForward = { prev_char = false } }) },
            { key = "T", mods = "NONE", action = wezterm.action.CopyMode({ JumpBackward = { prev_char = true } }) },
            { key = "F", mods = "NONE", action = wezterm.action.CopyMode({ JumpBackward = { prev_char = false } }) },
            -- 一番下へ
            { key = "G", mods = "NONE", action = wezterm.action.CopyMode("MoveToScrollbackBottom") },
            -- 一番上へ
            { key = "g", mods = "NONE", action = wezterm.action.CopyMode("MoveToScrollbackTop") },
            -- viewport
            { key = "H", mods = "NONE", action = wezterm.action.CopyMode("MoveToViewportTop") },
            { key = "L", mods = "NONE", action = wezterm.action.CopyMode("MoveToViewportBottom") },
            { key = "M", mods = "NONE", action = wezterm.action.CopyMode("MoveToViewportMiddle") },
            -- スクロール
            { key = "b", mods = "CTRL", action = wezterm.action.CopyMode("PageUp") },
            { key = "f", mods = "CTRL", action = wezterm.action.CopyMode("PageDown") },
            { key = "d", mods = "CTRL", action = wezterm.action.CopyMode({ MoveByPage = 0.5 }) },
            { key = "u", mods = "CTRL", action = wezterm.action.CopyMode({ MoveByPage = -0.5 }) },
            -- 範囲選択モード
            { key = "v", mods = "NONE", action = wezterm.action.CopyMode({ SetSelectionMode = "Cell" }) },
            { key = "v", mods = "CTRL", action = wezterm.action.CopyMode({ SetSelectionMode = "Block" }) },
            { key = "V", mods = "NONE", action = wezterm.action.CopyMode({ SetSelectionMode = "Line" }) },
            -- コピー
            { key = "y", mods = "NONE", action = wezterm.action.CopyTo("Clipboard") },
            -- コピーモードを終了
            {
                key = "Enter",
                mods = "NONE",
                action = wezterm.action.Multiple({
                    { CopyTo = "ClipboardAndPrimarySelection" },
                    { CopyMode = "Close" },
                }),
            },
            { key = "Escape", mods = "NONE", action = wezterm.action.CopyMode("Close") },
            { key = "c", mods = "CTRL", action = wezterm.action.CopyTo("Clipboard") },
            { key = "q", mods = "NONE", action = wezterm.action.CopyMode("Close") },
        },
    }
end

return M
