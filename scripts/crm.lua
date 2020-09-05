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

freeswitch.consoleLog("NOTICE", event:serialize())