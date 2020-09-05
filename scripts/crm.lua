function http_json_request(url, method, data)
    local http = require "socket.http"
    local json = require 'json'
    local ltn12 = require "ltn12"
    http.TIMEOUT = 2
    local json_data = json.encode(data)
    local response_body = {}
    local result, respcode, respheaders, respstatus = http.request {
        url = url,
        method = method,
        headers = {
            ["Content-Type"] = "",
            ["content-length"] = #json_data,
            ["Authorization"] = "Token cd68267d3b026e79e5261e31fbcb8640ce7d0fa5"
        },
        source = ltn12.source.string(data),
        sink = ltn12.sink.table(response_body)
    }
end



local direction = event:getHeader("Caller-Direction")
if direction ~= 'inbound' then
    return
end
freeswitch.consoleLog("NOTICE", event:serialize())

local src = event:getHeader("Caller-Caller-ID-Number")
local dst = event:getHeader("Caller-Destination-Number")
local event = event:getHeader("Event-Name")
local uuid = event:getHeader("variable_uuid")
local data = {}
data["uuid"] = uuid
data["direction"] = 'inbound'
local method = ""
local base_url = "http://127.0.0.1:8000/api/"
local url = ""
if event == 'CHANNEL_HANGUP_COMPLETE' then
    duration = event:getHeader("variable_duration")
    status = event:getHeader("variable_hangup_cause")
    method = 'PATCH'
    url = base_url .. "update"
    data["duration"] = duration
    data["status"] = status
else
    method = 'POST'
    url = base_url .. "create"
    data["src"] = src
    data["dst"] = dst
end

http_json_request(url, method, data)