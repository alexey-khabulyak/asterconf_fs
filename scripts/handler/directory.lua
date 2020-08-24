local database = require "dbh"


local user = params:getHeader("user")
local domain = params:getHeader("domain")
local xml = {}

local sql_string = [[select id, password from mod_lua_user where number = ]] .. user .. [[ limit 1;]]
local sql_result = database.make_query(sql_string)
if #sql_result > 0 then
    printDebugMsg("User " .. user .. " has been found\n");
    local db_user = sql_result[1]
    table.insert(xml, [[<?xml version="1.0" encoding="UTF-8" standalone="no"?>]])
    table.insert(xml, [[<document type="freeswitch/xml">]])
    table.insert(xml, [[  <section name="directory" description="">]])
    table.insert(xml, [[    <domain name="]] .. domain .. [[">]])
    table.insert(xml, [[      <groups>]])
    table.insert(xml, [[        <group name="default" description="">]])
    table.insert(xml, [[          <users>]])
    table.insert(xml, [[           <user id="]].. user ..[[">]])
    table.insert(xml, [[            <params>]]);
    table.insert(xml, [[              <param name="password" value="]] .. db_user["password"].. [["/>]])
    table.insert(xml, [[              <param name="dial-string" value="{^^:sip_invite_domain=${dialed_domain}:presence_id=${dialed_user}@${dialed_domain}}${sofia_contact(*/${dialed_user}@${dialed_domain})}"/>]])
    table.insert(xml, [[            </params>]])
    table.insert(xml, [[            <variables>]])
    if params:getHeader("sip_auth_method") ~= "REGISTER" then
        local sql_string = [[select * from mod_lua_uservar where user_id = ]] .. db_user["id"] .. [[;]]
        local sql_result = database.make_query(sql_string)
        for _,v in pairs(sql_result) do
            table.insert(xml, [[              <variable name="]] .. v.name .. [[" value="]] .. v.value .. [["/>]]);
        end
    end
    table.insert(xml, [[            </variables>]])
    table.insert(xml, [[           </user>]])
    table.insert(xml, [[          </users>]])
    table.insert(xml, [[        </group>]])
    table.insert(xml, [[      </groups>]])
    table.insert(xml, [[    </domain>]])
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