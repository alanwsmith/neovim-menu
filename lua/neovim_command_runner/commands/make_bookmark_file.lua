local M = {}

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
    -- print(count_lines(active_buffer))
    local document_folder = "/Users/alan/GrimoireBookmarks"
    -- local ksuid = get_ksuid()
    local datetime = get_datetime()
    --local parent_dir = document_folder .. "/" .. ksuid 
    local parent_dir = document_folder .. "/testing"
    local file_path = parent_dir .. "/source.neo"
    vim.system({'mkdir', '-p', parent_dir}):wait()
    vim.api.nvim_command('edit ' .. file_path)

    append_to_buffer(0, {
        "-- bookmark", 
        "-- title: ",
        "-- url: ",
    })

    append_to_buffer(0, {
        "-- bookmark", 
        "-- title: ",
        "-- url: ",
    })



    -- insert_lines({
    --     "-- bookmark", 
    --     "-- title: ",
    -- })

-- vim.api.nvim_buf_set_lines(
--   0, -1, -1, true, { "alfa" }
-- )
-- vim.api.nvim_buf_set_lines(
--   0, -1, -1, true, { "bravo" }
-- )

    -- insert_lines({
    --     "",
    --     "",
    --     "",
-- "-- page",
-- "-- created: " .. datetime, 
-- "-- updated: " .. datetime,
-- "-- id: " .. ksuid,
-- "-- template: bookmark", 
-- "-- status: done" 
    -- })

    -- vim.api.nvim_win_set_cursor(
    --     0,
    --     {3, 0}
    -- )
    -- vim.cmd('startinsert')

end

return M
