local pickers = require "telescope.pickers"
local M = {}

local live_multigrep = function(opts)
    opts = opts or {}
    opts.cwd = opts.cwd or vim.uv.cwd()
end

M.setup = function()
end

return M
