local database = require "dbh"
local xml = {}

local context = params:getHeader("Caller-Context")

local sql_string = "select * from mod_lua_context where name = '" .. context .. "' limit 1;"
local sql_result = database.make_query(sql_string)

if #sql_result > 0 then
    table.insert(xml, [[<?xml version="1.0" encoding="UTF-8" standalone="no"?>]]);
    table.insert(xml, [[<document type="freeswitch/xml">]]);
    table.insert(xml, [[  <section name="dialplan" description="">]]);
    table.insert(xml, [[    <context name="]] .. context .. [[">]]);
    table.insert(xml, [[      <extension name="]] .. context .. [[">]]); 
    table.insert(xml, [[        <condition>]]);

    local db_context = sql_result[1]
    local sql_string = [[select * from mod_lua_contextaction where context_id = ]] .. db_context.id .. [[ order by prio;]]
    local sql_result = database.make_query(sql_string)
    for _,v in pairs(sql_result) do
        if params:getHeader(v.condition_field) == v.condition_value then
            table.insert(xml, [[          <action application="]] .. v.action ..[[" data="]] .. v.action_value .. [["/>]]);
        end
    end

    table.insert(xml, [[        </condition>]]);
    table.insert(xml, [[      </extension>]]);
    table.insert(xml, [[    </context>]])
    table.insert(xml, [[  </section>]])
    table.insert(xml, [[</document>]])
end

if #xml > 0 then
    XML_STRING = table.concat(xml, "\n")
else
    XML_STRING = table.concat(not_found_table, "\n")
end
printDebugMsg(XML_STRING)
return XML_STRING