-- lua/gemini/util.lua
--
-- Utility functions module
--
-- last update: 2024.03.04.

local M = {}

-- splits a string with delimiters
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

-- checks if str has given prefix
function M.has_prefix(str, prefix)
  return str:sub(1, #prefix) == prefix
end

-- checks if str has given suffix
function M.has_suffix(str, suffix)
  return str:sub(-#suffix) == suffix
end

-- checks if str contains given substr
function M.contains(str, substr)
  return str:find(substr) ~= nil
end

-- sub-slices given array
function M.subslice(array, start_index, end_index)
  local sub_array = {}
  for i = start_index, end_index do
    sub_array[#sub_array + 1] = array[i]
  end
  return sub_array
end

-- strips outermost codeblock markdown off from given string
function M.strip_outermost_codeblock(str)
  local lines = M.split(str, '\n')
  if #lines >= 2 and M.has_prefix(lines[1], '```') and lines[#lines] == '```' then
    return M.join(M.subslice(lines, 2, #lines - 1), '\n')
  end

  return str
end

return M

