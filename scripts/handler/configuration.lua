local xml = {}
local database = require "dbh"

if XML_REQUEST["key_value"] == 'ivr.conf' then
    local ivr_name = params:getHeader("variable_current_application_data")
    local sql_string = [[select * from mod_lua_ivr where name = ']] .. ivr_name .. [[' limit 1;]]
    local sql_result = database.make_query(sql_string)
    if #sql_result > 0 then
        local ivr = sql_result[1]
        table.insert(xml, [[<?xml version="1.0" encoding="UTF-8" standalone="no"?>]])
        table.insert(xml, [[<document type="freeswitch/xml">]])
        table.insert(xml, [[  <section name="configuration">]])
        table.insert(xml, [[    <configuration name="ivr.conf" description="IVR menus">]])
        table.insert(xml, [[      <menus>]])
        table.insert(xml, [[        <menu name="]] .. ivr_name .. [["]])
        table.insert(xml, [[            greet-long="]] .. ivr["greet_long"] .. [["]])
        table.insert(xml, [[            greet-short="]] .. ivr["greet_short"] .. [["]])
        table.insert(xml, [[            invalid-sound="]] .. ivr["invalid_sound"] .. [["]])
        table.insert(xml, [[            exit-sound="]] .. ivr["exit_sound"] .. [["]])
        table.insert(xml, [[            max-failures="]] .. ivr["max_failures"] .. [["]])
        table.insert(xml, [[            timeout="]] .. ivr["timeout"] .. [[">]])

        local sql_string = [[select * from mod_lua_ivrentry where "IVR_id" = ']] .. ivr["id"] .. [[';]]
        local sql_result = database.make_query(sql_string)
        for _,v in pairs(sql_result) do
            table.insert(xml, [[          <entry action="]] .. v["action"] .. [[" digits="]] .. v["digit"] .. [[" param="]] .. v["param"] .. [["/>]])
        end

        table.insert(xml, [[        </menu>]])
        table.insert(xml, [[      </menus>]])
        table.insert(xml, [[    </configuration>]])
        table.insert(xml, [[  </section>]])
        table.insert(xml, [[</document>]])
    end
elseif XML_REQUEST["key_value"] == 'hiredis.conf' then
    table.insert(xml, [[<?xml version="1.0" encoding="UTF-8" standalone="no"?>]])
    table.insert(xml, [[<document type="freeswitch/xml">]])
    table.insert(xml, [[  <section name="configuration">]])
    table.insert(xml, [[    <configuration name="hiredis.conf" description="Hiredis">]])
    table.insert(xml, [[      <profiles>]])
    table.insert(xml, [[        <profile name="default">]])
    table.insert(xml, [[          <connections>]])
    table.insert(xml, [[            <connection name="primary">]])
    table.insert(xml, [[              <param name="hostname" value="127.0.0.1"/>]])
    table.insert(xml, [[              <param name="password" value=""/>]])
    table.insert(xml, [[              <param name="port" value="6379"/>]])
    table.insert(xml, [[              <param name="timeout_ms" value="500"/>]])
    table.insert(xml, [[            </connection>]])
    table.insert(xml, [[          </connections>]])
    table.insert(xml, [[          <params>]])
    table.insert(xml, [[            <param name="ignore-connect-fail" value="true"/>]])
    table.insert(xml, [[          </params>]])
    table.insert(xml, [[        </profile>]])
    table.insert(xml, [[      </profiles>]])
    table.insert(xml, [[    </configuration>]])
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