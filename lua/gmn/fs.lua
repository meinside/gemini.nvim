-- lua/gmn/fs.lua
--
-- File module
--
-- last update: 2025.03.04.

-- external dependencies
local path = require("plenary/path")

-- plugin modules
local config = require("gmn/config")

local M = {}

-- read and return the `api_key` value
function M.read_api_key()
	local api_key = nil
	local err = nil

	local filepath = config.options.configFilepath
	local f = io.open(path:new(filepath):expand(), "r")

	if f ~= nil then
		local str = f:read("*a")
		io.close(f)
		local parsed = vim.json.decode(str)

		if parsed.api_key then
			api_key = parsed.api_key
		else
			err = "failed to read `api_key` from: " .. filepath
		end
	else
		err = "failed to read: " .. filepath
	end

	return api_key, err
end

return M
