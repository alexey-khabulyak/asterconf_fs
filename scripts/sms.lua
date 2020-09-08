local event = freeswitch.Event("CUSTOM", "SMS::SEND_MESSAGE");

local api = freeswitch.API()

local local_ip = api:executeString("eval $${local_ip_v4}")

event:addHeader("proto", "sip");
event:addHeader("dest_proto", "sip");
event:addHeader("from", "freeswitch@" .. local_ip);
event:addHeader("from_full", "sip:freeswitch@" .. local_ip);
event:addHeader("to", "sip:kamailio@" .. local_ip .. ":5070");
event:addHeader("subject", "sip:kamailio@" .. local_ip.. ":5070");
event:addHeader("type", "text/html");
event:addHeader("hint", "the hint");
event:addHeader("replying", "true");
event:addHeader("sip_profile", "external");
event:addBody("TEST MESSAGE");

event:fire();