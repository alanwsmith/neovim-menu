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
