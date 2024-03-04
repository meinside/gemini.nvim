-- plugin/gemini.lua
--
-- Gemini plugin for neovim
--
-- last update: 2024.02.28.

local gemini = require'gemini'
local config = require'gemini/config'
local ui = require'gemini/ui'
local util = require'gemini/util'

local function error(msg)
  vim.notify(msg, vim.log.levels.ERROR)
end

local function warn(msg)
  vim.notify(msg, vim.log.levels.WARN)
end

local function debug(msg)
  if config.options.verbose then
    vim.notify(msg, vim.log.levels.INFO)
  end
end

-- :GeminiGenerate [prompt]
--   generate content from the given prompt
--
-- :'<,'>GeminiGenerate
--   replace selected range with generated content from the selected range as a prompt
--
-- :'<,'>GeminiGenerate [prompt]
--   replace selected range with generated content from the given prompt
--
vim.api.nvim_create_user_command(
  'GeminiGenerate',
  function(opts)
    debug('opts of command `GeminiGenerate`: ' .. vim.inspect(opts))

    -- generate texts with given prompt,
    if opts.range == 0 then -- if there was no selected range,
      if #opts.fargs > 0 then
        debug('using command parameter as a prompt: ' .. opts.fargs[1])

        -- do the generation
        local parts, err = gemini.generate({ opts.fargs[1] })
        if err ~= nil then
          error(err)
        else
          -- strip outermost codeblock
          if config.options.stripOutermostCodeblock() then
            for i, _ in ipairs(parts) do
              parts[i] = util.strip_outermost_codeblock(parts[i])
            end
          end
          local generated = util.join(parts, '\n\n')

          -- and insert the generated content
          ui.insert_text_at_current_cursor(generated)
        end
      else
        warn('No prompt was given.')
      end
    else -- if there was some selected range,
      local start_row, start_col, end_row, end_col = ui.get_selection()
      local selected = ui.get_text(start_row, start_col, end_row, end_col)

      local prompts = {}
      if selected ~= nil then
        debug('using selected range as a prompt: ' .. selected)

        table.insert(prompts, selected)
      end
      if #opts.fargs > 0 then
        debug('using command parameter as a prompt: ' .. opts.fargs[1])

        table.insert(prompts, opts.fargs[1])
      end

      -- do the generation
      local parts, err = gemini.generate(prompts)
      if err ~= nil then
        error(err)
      else
        -- strip outermost codeblock
        if config.options.stripOutermostCodeblock() then
          for i, _ in ipairs(parts) do
            parts[i] = util.strip_outermost_codeblock(parts[i])
          end
        end
        local generated = util.join(parts, '\n\n')

        -- and replace the selected range with generated content
        ui.replace_text(start_row, start_col, end_row, end_col, generated)
      end
    end
  end,
  { range = true, nargs = '?' }
)

