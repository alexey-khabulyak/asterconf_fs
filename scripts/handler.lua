package.path = package.path .. ";/usr/share/freeswitch/scripts/?.lua;"
require "scripts";

api = freeswitch.API()

global_cache = false

if (params:serialize() ~= nil) then
    printDebugMsg("[xml_handler] Params:\n" .. params:serialize() .. "\n");
end


printDebugMsg("[xml_handler] Section: " .. XML_REQUEST["section"] .. "\n");
printDebugMsg("[xml_handler] Tag Name: " .. XML_REQUEST["tag_name"] .. "\n");
printDebugMsg("[xml_handler] Key Name: " .. XML_REQUEST["key_name"] .. "\n");
printDebugMsg("[xml_handler] Key Value: " .. XML_REQUEST["key_value"] .. "\n");


not_found_table = {}
table.insert(not_found_table, [[<?xml version="1.0" encoding="UTF-8" standalone="no"?>]]);
table.insert(not_found_table, [[<document type="freeswitch/xml">]]);
table.insert(not_found_table, [[  <section name="result">]]);
table.insert(not_found_table, [[    <result status="not found" />]]);
table.insert(not_found_table, [[  </section>]]);
table.insert(not_found_table, [[</document>]]);


if (XML_REQUEST["section"] == "dialplan") then
    dofile("/usr/share/freeswitch/scripts/handler/dialplan.lua");
elseif (XML_REQUEST["section"] == "directory") then
    dofile("/usr/share/freeswitch/scripts/handler/directory.lua");
elseif (XML_REQUEST["section"] == "configuration") then
    dofile("/usr/share/freeswitch/scripts/handler/configuration.lua");
end