con = freeswitch.EventConsumer("all");
event = con:pop(1)
freeswitch.consoleLog("CRIT", event:serialize("xml"))