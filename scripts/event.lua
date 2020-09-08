local event = freeswitch.Event("CUSTOM", "new call");
event:addHeader("some_header", "headers_value");
event:addBody("TEST MESSAGE");
event:fire();