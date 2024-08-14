local M = {}

local function map(mode, from, to, desc, opts)
  opts = opts or { silent = true }
  opts.desc = desc
  vim.keymap.set(mode, from, to, opts)
end

for _, v in ipairs({'n', 'x', 'o', 'i', 'v', 't'}) do
  M[v .. 'map'] = function(from, to, desc, opts)
    map(v, from, to, desc, opts)
  end
end

M['map'] = function(v, from, to, desc, opts)
    map(v, from, to, desc, opts)
end

return M
