local ngx = require "ngx"

-- regex for to search the key
local key_regex = ".*/(.*)"
local function matchKey(uri)
    local last = ""
    for match in string.gmatch(uri, key_regex) do
        last = match
    end
    return last
end

local base64_part = matchKey(ngx.var.uri)
ngx.log(ngx.INFO, 'part of url match: ' .. base64_part)

local external = ngx.decode_base64(base64_part)
ngx.log(ngx.INFO, 'external: ' .. external)

if (external == nil) or (#external == 0) then
    ngx.log(ngx.ERR, 'ERR: parse stream url error! info: ' .. base64_part)
    ngx.say('Internal Server Error: during parce the streaming url')
    ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end
return external
