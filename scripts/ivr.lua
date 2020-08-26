session:answer()
session:sleep(500)

digits = session:playAndGetDigits(2, 5, 3, 3000, "#", "ivr/ivr-enter_ext.wav", "ivr/ivr-that_was_an_invalid_entry.wav", "\\d+")

session:consoleLog("info", "Got DTMF digits: ".. digits .."\n")