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

local get_ksuid = function()
    local response = vim.system(
        {"bash", "-c", 
'ksuid | sed -r "s@(..)(..)(..)(..).*@\\\\1/\\\\2/\\\\3/\\\\4@" | tr "[:upper:]" "[:lower:]"'},
        { text = true }):wait()
    local output = response['stdout']:gsub(
        "\n", ""
    )
    return output
end

local insert_lines = function(lines)
    local window_number = 0
    local buffer_number = vim.api.nvim_win_get_buf(
        window_number
    )
    local row, col = unpack(
        vim.api.nvim_win_get_cursor(
            window_number
        )
    )
    local line_count = 0
    vim.api.nvim_buf_set_lines(
        buffer_number, 
        row - 1, 
        row - 1, 
        false,
        lines
    )
    for _ in pairs(lines) do
        line_count = line_count + 1
    end
    vim.api.nvim_win_set_cursor(
        window_number,
        {1, 0}
    )
end

M.run = function(active_buffer, floading_window, floating_buffer)
    local document_folder = "/Users/alan/GrimoireShorts"
    local ksuid = get_ksuid()
    local datetime = get_datetime()
    local parent_dir = document_folder .. "/" .. ksuid 
    local file_path = parent_dir .. "/source.neo"
    vim.system({'mkdir', '-p', parent_dir}):wait()
    vim.api.nvim_command('edit ' .. file_path)
    insert_lines({
        "-- p", 
        "",
        "",
        "",
"-- page",
"-- created: " .. datetime, 
"-- updated: " .. datetime,
"-- id: " .. ksuid,
"-- template: short", 
"-- status: done" 
    })
    vim.api.nvim_win_set_cursor(
        0,
        {3, 0}
    )
    vim.cmd('startinsert')
end

return M
