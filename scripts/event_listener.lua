con = freeswitch.EventConsumer("all");
event = con:pop()
freeswitch.consoleLog("CRIT", event:serialize("xml"))