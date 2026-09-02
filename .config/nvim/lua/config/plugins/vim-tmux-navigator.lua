local function open_tmux_shell()
  if vim.env.TMUX == nil then
    vim.notify('Tmux shell requires Neovim to run inside tmux', vim.log.levels.ERROR)
    return
  end

  local buffer_name = vim.api.nvim_buf_get_name(0)
  local directory

  if buffer_name == '' then
    directory = vim.fn.getcwd()
  elseif vim.fn.isdirectory(buffer_name) == 1 then
    directory = buffer_name
  else
    directory = vim.fs.dirname(buffer_name)
  end

  vim.system({ 'tmux', 'split-window', '-v', '-c', directory }, {}, function(result)
    if result.code ~= 0 then
      vim.schedule(function()
        vim.notify('Could not open tmux shell: ' .. result.stderr, vim.log.levels.ERROR)
      end)
    end
  end)
end

return {
    "christoomey/vim-tmux-navigator",
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
    },
    keys = {
        { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
        { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
        { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
        { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
        { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        { '<leader>ts', open_tmux_shell, desc = 'Open tmux shell in buffer directory' },
    }
}
