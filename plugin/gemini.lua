-- plugin/gemini.lua
--
-- Gemini plugin for neovim
--
-- last update: 2025.02.20.

local gemini = require("gemini")
local config = require("gemini/config")
local ui = require("gemini/ui")
local util = require("gemini/util")

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
vim.api.nvim_create_user_command("GeminiGenerate", function(opts)
	debug("opts of command `GeminiGenerate`: " .. vim.inspect(opts))

	-- generate texts with given prompt,
	if opts.range == 0 then -- if there was no selected range,
		if #opts.fargs > 0 then
			debug("using command parameter as a prompt: " .. opts.fargs[1])

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

				-- split lines
				local lines = util.split_lines(parts)

				-- and insert the generated content
				ui.insert_text_at_current_cursor(lines)
			end
		else
			warn("No prompt was given.")
		end
	else -- if there was some selected range,
		local start_row, start_col, end_row, end_col = ui.get_selection()
		local selected = ui.get_text(start_row, start_col, end_row, end_col)

		local prompts = {}
		if selected ~= nil then
			debug("using selected range as a prompt: " .. selected)

			table.insert(prompts, selected)
		end
		if #opts.fargs > 0 then
			debug("using command parameter as a prompt: " .. opts.fargs[1])

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

			-- split lines
			local lines = util.split_lines(parts)

			-- and replace the selected range with generated content
			ui.replace_text(start_row, start_col, end_row, end_col, lines)
		end
	end
end, { range = true, nargs = "?" })

-- :GeminiCommitLog
--   generate a nice commit log from the content of current file (eg. COMMIT_EDITMSG)
--
-- :'<,'>GeminiCommitLog
--   replace selected range with generated content from the selected range as a prompt
--
vim.api.nvim_create_user_command("GeminiCommitLog", function(opts)
	debug("opts of command `GeminiCommitLog`: " .. vim.inspect(opts))

	local prompt = "Please generate a commit message adhering to the Conventional Commits v1.0.0 specification:\n\n"

	-- generate texts with given prompt,
	if opts.range == 0 then -- if there was no selected range,
		local text = util.remove_comments(ui.whole_buffer_lines())
		local prompts = { prompt .. text }

		debug("using prompt: " .. prompts[1])

		-- do the generation
		local parts, err = gemini.generate(prompts)
		if err ~= nil then
			error(err)
		else
			-- split lines
			local lines = util.split_lines(parts)

			-- FIXME: generated lines have no empty line between the first and the next one
			lines = util.insert_empty_line_after_first(lines)

			-- and replace whole file with the generated content
			ui.replace_whole_text(lines)
		end
	else -- if there was some selected range,
		local start_row, start_col, end_row, end_col = ui.get_selection()
		local selected = ui.get_text(start_row, start_col, end_row, end_col)

		local prompts = {}
		if selected ~= nil then
			debug("using selected range as a prompt: " .. selected)

			table.insert(prompts, prompt .. selected)
		end
		if #opts.fargs > 0 then
			debug("using command parameter as a prompt: " .. opts.fargs[1])

			table.insert(prompts, prompt .. opts.fargs[1])
		end

		-- do the generation
		local parts, err = gemini.generate(prompts)
		if err ~= nil then
			error(err)
		else
			-- split lines
			local lines = util.split_lines(parts)

			-- FIXME: generated lines have no empty line between the first and the next one
			lines = util.insert_empty_line_after_first(lines)

			-- merge generated contents and replace the selected range with it
			ui.replace_text(start_row, start_col, end_row, end_col, lines)
		end
	end
end, { range = true })
