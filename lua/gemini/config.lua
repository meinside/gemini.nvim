-- lua/gemini/config.lua
--
-- Configuration module
--
-- last update: 2024.02.28.

local M = {
  -- constants
  defaultConfigFilepath = '~/.config/gemini.nvim/config.json',
  defaultTimeoutMsecs = 30 * 1000,
}

-- default configuration
M.options = {
  configFilepath = M.defaultConfigFilepath,
  timeout = M.defaultTimeoutMsecs,
  verbose = false,
}

-- override configurations
function M.override(opts)
  opts = opts or {}

  M.options = vim.tbl_deep_extend('force', {}, M.options, opts)
end

return M

