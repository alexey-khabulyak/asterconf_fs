local json = require "json"
local api = freeswitch.API()

local local_ip = api:executeString("eval $${local_ip_v4}")
local reg_users = api:executeString("show registrations as json")

local t = json.decode(reg_users)

for k,v in ipairs(t["rows"]) do
    local event = freeswitch.Event("CUSTOM", "SMS::SEND_MESSAGE");
    event:addHeader("proto", "sip");
    event:addHeader("dest_proto", "sip");
    event:addHeader("from", "freeswitch@" .. local_ip);
    event:addHeader("from_full", "sip:freeswitch@" .. local_ip);
    event:addHeader("to", "sip:" .. v["reg_user"] .. "@" .. v["network_ip"] .. ":" .. v["network_port"]);
    event:addHeader("subject", "sip:" .. v["reg_user"] .. "@" .. v["network_ip"].. ":" .. v["network_port"]); 
    event:addHeader("type", "text/html");
    event:addHeader("hint", "the hint");
    event:addHeader("replying", "true");
    event:addHeader("sip_profile", "internal");
    event:addBody("TEST MESSAGE");
    event:fire();
end