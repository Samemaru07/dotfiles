local wezterm = require("wezterm")
local M = {}

M.is_windows = wezterm.target_triple:find("windows") ~= nil

M.get_cwd_path = function(pane)
    local cwd = pane:get_current_working_dir()
    if cwd then
        local path = cwd.file_path

        if path:sub(1, 7) == "file://" then
            path = path:sub(8)
        end

        path = path:gsub("\\", "/")

        if path:match("^/[A-Za-z]:/") then
            path = path:sub(2)
        end

        local drive, rest = path:match("^([A-Za-z]):/(.*)")
        if drive then
            path = "/mnt/" .. drive:lower() .. "/" .. rest
        end

        local win_home = wezterm.home_dir:gsub("\\", "/")
        local win_drive, win_rest = win_home:match("^([A-Za-z]):/(.*)")
        if win_drive then
            local win_mnt_base = "/mnt/" .. win_drive:lower() .. "/" .. win_rest
            if path:lower():sub(1, #win_mnt_base) == win_mnt_base:lower() then
                local suffix = path:sub(#win_mnt_base + 1)
                if suffix == "" or suffix:sub(1, 1) == "/" then
                    local wsl_user = os.getenv("USER")
                    if wsl_user then
                        path = "/home/" .. wsl_user .. "/win" .. suffix
                    end
                end
            end
        end

        return path
    end
    return nil
end

return M
