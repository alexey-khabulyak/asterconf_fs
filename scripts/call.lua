api = freeswitch.API()

contact1 = api:executeString("sofia_contact 1000");
contact2 = api:executeString("sofia_contact 1010");

freeswitch.consoleLog("NOTICE", "Session1 contact: " .. contact1)
freeswitch.consoleLog("NOTICE", "Session2 contact: " .. contact2)

session1 = freeswitch.Session('[origination_caller_id_number=freeswitch,origination_caller_id_name=freeswitch]' .. contact1);

if session1:ready() then
    freeswitch.consoleLog("NOTICE", "Session1 is ready")
    session1:execute("ring_ready")
    session1:setVariable("ringback", "%(2000, 4000, 440.0, 480.0")
    session2 = freeswitch.Session('[origination_caller_id_number=1000]' .. contact2, session1)
    if session2:ready() then
        freeswitch.consoleLog("NOTICE", "Session1 is ready. Bridging")
        freeswitch.bridge(session1, session2)
    else
        freeswitch.consoleLog("CRIT", "session2 hangupCause: " .. session2:hangupCause())
    end
else
    freeswitch.consoleLog("CRIT", "session1 hangupCause: " .. session1:hangupCause())
end