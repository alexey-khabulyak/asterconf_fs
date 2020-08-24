-- local sql_string = "select * from mod_lua_user limit 1;"
-- local sql_result = database.make_query(sql_string)
-- for _,v in pairs(sql_result) do
--     printDebugMsg(v.password .. "\n")
-- end

local database = {}
function database.make_query(sql)
  -- результирующая таблица. возвращается из функции
  local result = {} 
  -- callback функция. ей обрабатывается каждая строка из вывода SQL
  local function callback_query(row)
    -- записываем в таблицу значение строки. ключ - название колонки, значение - значение колонки
    local line = {}
    for key,val in pairs(row) do
      line[key]=val
    end
    -- в общую таблицу добавляем таблицу line. в итоге имеем таблицу таблиц.
    table.insert(result, line)
    return 0
  end
  -- dbh коннектор. см. /etc/odbc.ini
  local dbh = freeswitch.Dbh("pgsql://hostaddr=127.0.0.1 dbname='asterconf_fs' user=asterconf_fs password='asterconf_fs' options='-c client_min_messages=NOTICE' application_name='tech4u'")
  -- коннектимся к базе
  assert(dbh:connected())
  -- делаем запрос с помощью protected call
  check_error = pcall(dbh.query, dbh, sql, callback_query)
  -- освобождаем соединение. Опционально, т.к. garbage collection после return сам это сделает. Но лучше перебздеть.
  dbh:release()
  -- возвращаем таблицу, вида 1 - table1, 2 - table2, где table1,table2.... это таблицы значение каждой строки sql.
  return result

end

return database