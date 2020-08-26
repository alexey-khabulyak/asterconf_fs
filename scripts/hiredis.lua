--b64 = require "base64"
local cache = {}

function cache.get(key)
  profile = 'default'
  local result = api:execute('hiredis_raw', profile .. ' get ' .. key)
  if isempty(result) or result == '-ERR no reply' then return nil end
  --return b64.dec(result)
  return result
end

function cache.set(key, value, expire)
  --value = b64.enc(value)
  key = key or 'empty'
  expire = expire and tostring(expire) or "1800"
  profile = 'default'
  local status = api:execute("hiredis_raw", profile .. " setex " .. key .. " " .. expire .. " '" .. value .. "'")
  return status == 'OK'
end


return cache