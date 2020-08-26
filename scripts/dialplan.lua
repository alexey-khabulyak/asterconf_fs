ACTIONS = {}

--for n in pairs(_G) do freeswitch.consoleLog("notice",n) end

local uuid = session:get_uuid()
freeswitch.consoleLog("notice", "UUID: " .. uuid)
api = freeswitch.API()
local uuid_dump = api:execute("uuid_dump", uuid)
freeswitch.consoleLog("notice", uuid_dump)

session:answer()
table.insert(ACTIONS, {"log", "NOTICE DIALPLAN LUA"})
table.insert(ACTIONS, "hangup")