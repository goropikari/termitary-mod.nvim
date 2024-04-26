local M = {}

M.state = {
  terminal_id = nil -- Set by the `activate` function
}

-- Use the current or create a new terminal buffer
local function activate()
  if M.state.terminal_id and vim.api.nvim_buf_is_valid(M.state.terminal_id) then
    M.state.terminal_id = nil
  end
  if not M.state.terminal_id then
    vim.api.nvim_command('terminal')
    vim.api.nvim_feedkeys('G', 't', false)
    M.state.terminal_id = vim.b.terminal_job_id
  end
end

-- Send text with a newline
M.type = function(words)
  activate()
  M.state.last_sent = ''

  for _, word in ipairs(words) do
    local with_space = word .. ' '
    vim.api.nvim_chan_send(M.state.terminal_id, word .. ' ')
    M.state.last_sent = M.state.last_sent .. with_space
  end

  vim.api.nvim_chan_send(M.state.terminal_id, '\r')
end

return M
