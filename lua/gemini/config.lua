-- lua/gemini/config.lua
--
-- Configuration module
--
-- last update: 2024.03.04.

local M = {
  -- constants
  defaultConfigFilepath = '~/.config/gemini.nvim/config.json',
  defaultTimeoutMsecs = 30 * 1000,
  defaultStripOutermostCodeblock = function()
    -- don't strip codeblock markdowns in markdown files
    return vim.bo.filetype ~= 'markdown'
  end,
}

-- default configuration
M.options = {
  configFilepath = M.defaultConfigFilepath,
  timeout = M.defaultTimeoutMsecs,
  stripOutermostCodeblock = M.defaultStripOutermostCodeblock,

  verbose = false,
}

-- override configurations
function M.override(opts)
  opts = opts or {}

  M.options = vim.tbl_deep_extend('force', {}, M.options, opts)
end

return M

