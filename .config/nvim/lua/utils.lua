local M = {}

function M.is_large_file(bufnr, max_file_size)
  local file_name = vim.api.nvim_buf_get_name(bufnr)
  local ok, stat = pcall(vim.uv.fs_stat, file_name)
  return ok and stat and stat.size > max_file_size
end

local function map(mode, from, to, desc, opts)
  opts = opts or { silent = true }
  opts.desc = desc
  vim.keymap.set(mode, from, to, opts)
end

for _, v in ipairs({'n', 'x', 'o', 'i', 'v', 't', 'c'}) do
  M[v .. 'map'] = function(from, to, desc, opts)
    map(v, from, to, desc, opts)
  end
end

M['map'] = function(v, from, to, desc, opts)
    map(v, from, to, desc, opts)
end

return M
