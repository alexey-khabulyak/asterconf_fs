freeswitch.consoleLog("NOTICE", event:serialize())
local subclass = event:getHeader("Event-Subclass")
freeswitch.consoleLog("CRIT", subclass)
