local event = freeswitch.Event("CUSTOM", "SMS::SEND_MESSAGE");

event:addHeader("proto", "sip");
event:addHeader("dest_proto", "sip");
event:addHeader("from", "freeswitch@10.34.134.14");
event:addHeader("from_full", "sip:freeswitch@10.34.134.14");
event:addHeader("to", "sip:1019@62.76.112.134");
event:addHeader("subject", "sip:1019@62.76.112.134");
event:addHeader("type", "text/html");
event:addHeader("hint", "the hint");
event:addHeader("replying", "true");
event:addHeader("sip_profile", "external");
event:addBody("Hello from Seven Du! Have fun!");
 
-- freeswitch.consoleLog("info", event:serialize());
event:fire();