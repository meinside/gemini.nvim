-- lua/gemini/ui.lua
--
-- UI module
--
-- last update: 2024.02.28.

-- plugin modules
local util = require'gemini/util'

local M = {}

-- get selected range from visual block
function M.get_selection()
  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, '<'))
  local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, '>'))

  return start_row, start_col, end_row, end_col
end

-- get text from range
function M.get_text(start_row, start_col, end_row, end_col)
  local n_lines = math.abs(end_row - start_row) + 1
  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)

  if #lines <= 0 then
    return nil
  else
    lines[1] = string.sub(lines[1], start_col, -1)
    if n_lines == 1 then
      lines[n_lines] = string.sub(lines[n_lines], 1, end_col - start_col + 1)
    else
      lines[n_lines] = string.sub(lines[n_lines], 1, end_col)
    end
    return table.concat(lines, '\n')
  end
end

-- clear and replace text at given range
function M.replace_text(start_row, start_col, end_row, end_col, text)
  vim.api.nvim_buf_set_text(0, start_row - 1, start_col, end_row - 1, end_col, {})
  vim.api.nvim_buf_set_text(0, start_row - 1, start_col, start_row - 1, start_col, { unpack(util.split(text, '\n')) })
end

-- insert given text at current cursor position
function M.insert_text_at_current_cursor(text)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { unpack(util.split(text, '\n')) })
end

return M

