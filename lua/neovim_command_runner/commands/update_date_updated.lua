local M = {}

local get_datetime = function()
    local response = vim.system(
        {"date", "+%Y-%m-%dT%H:%M:%S-04:00"},
        { text = true }):wait()
    local output = response['stdout']:gsub(
        "\n", ""
    )
    return output
end

-- local open_floating_window = function()
--     local active_buffer = vim.api.nvim_get_current_buf()
--     local opts = {
--         style="minimal", 
--         relative='editor',
--         border='single'
--     }
--     opts.width = vim.api.nvim_win_get_width(0) - 18
--     opts.height = vim.api.nvim_win_get_height(0) - 12
--     opts.col = (vim.api.nvim_win_get_width(0) / 2) - (opts.width / 2)
--     opts.row = (vim.api.nvim_win_get_height(0) / 2) - (opts.height / 2)
--     floating_buffer = vim.api.nvim_create_buf(false, true)
--     floating_window = vim.api.nvim_open_win(floating_buffer, true, opts)
--     vim.keymap.set("n", "<ESC>", function()
--         vim.api.nvim_win_close(floating_window, true)
--         end, 
--         { buffer = floating_buffer }
--     )
--     return floating_buffer
-- end

local replace_line_in_buffer = function(line_number, buffer_number, content)
    if type(content) == "string" then
        content = { content }
    end
    vim.api.nvim_buf_set_lines(
        buffer_number, 
        line_number - 1, 
        line_number, 
        false, 
        content
    )
end

M.run = function(active_buffer, floating_window, floating_buffer)
    -- local new_floating_buffer = open_floating_window()
    local lines = vim.api.nvim_buf_get_lines(active_buffer, 0, -1, false)
    for line_num, line in ipairs(lines) do
        if string.find(line, "^-- updated: ") ~= nil then
            replace_line_in_buffer(
                line_num,
                active_buffer,
                "-- updated: " .. get_datetime()
            )
        end
    end
end

return M
