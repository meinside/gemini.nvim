-- lua/gemini/util.lua
--
-- Utility functions module
--
-- last update: 2024.02.28.

local M = {}

-- split a string with delimiters
--
-- https://stackoverflow.com/questions/19262761/lua-need-to-split-at-comma
function M.split(source, delimiters)
  local elements = {}
  local pattern = '([^'..delimiters..']+)'
  _ = string.gsub(source, pattern, function(value)
    elements[#elements + 1] = value
  end)
  return elements
end

-- joins a string array with given delimiter
function M.join(strs, delim)
  return table.concat(strs, delim)
end

return M

