-- lua/gmn.lua
--
-- last update: 2025.03.04.

-- plugin modules
local config = require("gmn/config")
local net = require("gmn/net")

local M = {}

-- setup function for configuration
function M.setup(opts)
	config.override(opts)
end

-- generate text parts with given prompts and return them
function M.generate(prompts)
	local parts = {}
	local res, err = net.request_content_generation(prompts)

	if err == nil then
		-- take the first candidate,
		if res ~= nil and res.candidates ~= nil and #res.candidates > 0 then
			local candidate = res.candidates[1]
			if candidate.content ~= nil and candidate.content.parts ~= nil and #candidate.content.parts > 0 then
				for i, _ in ipairs(candidate.content.parts) do
					parts[i] = candidate.content.parts[i].text
				end
			else
				err = "No content parts returned from Gemini API."
			end
		else
			err = "No candidate was returned from Gemini API."
		end
	end

	return parts, err
end

-- export things
return M
