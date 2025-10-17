-- outputs the template for a new post

local M = {}

local move_cursor_to_end_of_buffer = function()
    local source_lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
    local line = 0
    for _ in pairs(source_lines) do 
        line = line + 1 
    end
    local character = string.len(
        source_lines[line]
    )
    vim.api.nvim_win_set_cursor(0, {line, character})
end

local append_to_buffer = function(buffer_number, new_lines) 
    if type(new_lines) == "string" then
        new_lines = { new_lines }
    end
    local source_lines = vim.api.nvim_buf_get_lines(buffer_number, 0, -1, true)
    local count = 0
    for _ in pairs(source_lines) do 
        count = count + 1 
    end
    if count == 1 and source_lines[count] == "" then
        vim.api.nvim_buf_set_lines(
            buffer_number, 0, -1, true, new_lines 
        )
    else 
        vim.api.nvim_buf_set_lines(
            buffer_number, count, count, true, new_lines 
        )
    end
end

local count_lines = function(buffer_number) 
    local lines = vim.api.nvim_buf_get_lines(buffer_number, 0, -1, true)
    local count = 0
    for _ in pairs(lines) do 
        count = count + 1 
    end
    return count
end

local get_datetime = function()
    local response = vim.system(
        {"date", "-Iseconds"},
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
    local ksuid = get_ksuid()
    local datetime = get_datetime()
    append_to_buffer(0, {
        "-- title: ",
    })
    move_cursor_to_end_of_buffer()
    append_to_buffer(0, {
        "", 
        "", 
        "",
        "-- page",
        "-- created: " .. datetime, 
        "-- updated: " .. datetime,
        "-- id: " .. ksuid,
        "-- template: post", 
        "-- status: draft" 
    })

end

return M


