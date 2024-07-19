-- lua/gemini/config.lua
--
-- Configuration module
--
-- last update: 2024.07.19.

local M = {
  -- constants
  defaultConfigFilepath = '~/.config/gemini.nvim/config.json',
  defaultTimeoutMsecs = 30 * 1000,
  defaultModel = 'gemini-1.5-flash-latest',
  defaultSafetyThreshold = 'BLOCK_ONLY_HIGH',
  defaultStripOutermostCodeblock = function()
    -- don't strip codeblock markdowns in markdown files
    return vim.bo.filetype ~= 'markdown'
  end,
}

-- default configuration
M.options = {
  configFilepath = M.defaultConfigFilepath,
  timeout = M.defaultTimeoutMsecs,
  model = M.defaultModel,
  safetyThreshold = M.defaultSafetyThreshold,
  stripOutermostCodeblock = M.defaultStripOutermostCodeblock,

  verbose = false,
}

-- override configurations
function M.override(opts)
  opts = opts or {}

  M.options = vim.tbl_deep_extend('force', {}, M.options, opts)
end

return M

