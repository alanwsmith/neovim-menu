local M = {}

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

local open_floating_window = function()
  local opts = {
    style="minimal", 
    relative='editor',
    border='single'
  }
  opts.width = vim.api.nvim_win_get_width(0) - 18
  opts.height = vim.api.nvim_win_get_height(0) - 12
  opts.col = (vim.api.nvim_win_get_width(0) / 2) - (opts.width / 2)
  opts.row = (vim.api.nvim_win_get_height(0) / 2) - (opts.height / 2)
  M.floating_buffer = vim.api.nvim_create_buf(false, true)
  M.floating_window = vim.api.nvim_open_win(M.floating_buffer, true, opts)
  vim.keymap.set("n", "<ESC>", function()
      vim.api.nvim_win_close(M.floating_window, true)
    end, 
    { buffer = M.floating_buffer }
  )
end

list_commands = function()
    local response = vim.system(
        {'ls', '/Users/alan/workshop/neovim_command_runner.nvim/commands'}, 
        { text = true }):wait()
    local lines =  {} 
    for line in response['stdout']:gmatch '[^\n]+' do
        table.insert(lines, line)
    end
    vim.api.nvim_buf_set_lines(
        M.floating_buffer, 
        0, 
        -1, 
        false, 
        lines
    )
end

M.open_command_window = function()
    local buffer_number = open_floating_window()
    list_commands()
end

return M

