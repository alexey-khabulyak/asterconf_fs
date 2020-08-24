--Обёртка к freeswitch.COnsoleLOG. Для логирования
function printDebugMsg (...)
    local msg, dbg_type, fslog_type = ...
    -- Если не передан тип лога ФС, то делаем его notice
    fslog_type = fslog_type or 'NOTICE'
    -- Если не передан тип дебага, то смотрим fsconsolemsg
    if dbg_type == nil then
      dbg_type = debug.fsConsoleMsg
    end
  
    if dbg_type == true and msg == nil then
      msg = 'nil message'
      freeswitch.consoleLog(fslog_type, msg)
    else
      freeswitch.consoleLog(fslog_type, msg)
    end
end

-- проверка строки. возвращает true если пустая или nil
function isempty(s)
  return s == nil or s == ''
end