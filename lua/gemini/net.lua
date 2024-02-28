-- lua/gemini/net.lua
--
-- Network module
--
-- last update: 2024.02.28.

-- external dependencies
local curl = require'plenary/curl'

-- plugin modules
local fs = require'gemini/fs'
local config = require'gemini/config'

-- constants
local model = 'gemini-pro'
local contentType = 'application/json'
local baseurl = 'https://generativelanguage.googleapis.com'

-- generate a request url
local function request_url(endpoint, apiKey)
  return baseurl .. endpoint .. '?key=' .. apiKey
end

local M = {}

-- request generation of content
--
-- https://ai.google.dev/tutorials/rest_quickstart#text-only_input
function M.request_content_generation(prompts)
  local apiKey, err = fs.read_api_key()
  if err ~= nil then
    return nil, err
  end

  local endpoint = '/v1beta/models/' .. model .. ':generateContent'
  local params = {
    contents = {
      { role = 'user', parts = {} }
    }
  }
  for i, _ in ipairs(prompts) do
    params.contents[1].parts[i] = { text = prompts[i] }
  end

  local res = curl.post(request_url(endpoint, apiKey), {
    headers = {
      ['Content-Type'] = contentType,
    },
    raw_body = vim.json.encode(params),
    timeout = config.options.timeout,
  })

  if res.status == 200 and res.exit == 0 then
    res = vim.json.decode(res.body)
  else
    err = 'request failed with http status: ' .. res.status .. ', curl exit code: ' .. res.exit
  end

  return res, err
end

return M

