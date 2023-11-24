local ADDON_NAME, addonTable = ...;

local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "deDE")
if not L then return end

L["SHARDS_NAME"] = "Splitter der Illusion"
L["CHAT_MSG_SYSTEM_PATTERN"] = "^Freigeschaltetes Aussehen zur Transmogrifizierung: (\124c%x+\124Hitem:(%d+):[:%d]+\124h%[(.-)%]\124h\124r)$"
L["MSG_PATTERN_TRACKING"] = "Erfasse %s"

L["NOTIFY_DB_RESET_CMD"] = "Die Addon-Datenbank wurde zurückgesetzt."
L["NOTIFY_DB_RESET_FIRST_TIME"] = "Die Addon-Datenbank ist leer, weil dieses Addon zum ersten Mal geladen wurde oder weil der WTF-Ordner gelöscht wurde."
L["NOTIFY_DB_RESET_VERSION_MISMATCH"] = "Die Addon-Datenbank wurde zurückgesetzt, weil die DB-Version nicht mit dieser Version des Addons übereinstimmte."
L["NOTIFY_DB_EMPTY"] = "Um bereits freigeschaltene Transmog-Aussehen zu erfassen, besuche den |cff66bbffErhabener Illusionist|r NPC und blättere durch alle bekannte Aussehen."

L["cmd_help_commands"]	= format("|c%s%s|r\n", "FFffff00", "/tmt help") .. "-- zeigt Liste der Befehle."
L["cmd_help_howto"]	= format("|c%s%s|r\n", "FFffff00", "/tmt howto") .. "-- erklärt wie man dieses Addon benutzt."
L["cmd_help_item_id"]	= format("|c%s%s |c%s%s|r\n", "FFffff00", "/tmt item", "ff66bbff", "ITEMID") .. "-- überprüft via Item-ID, ob dieses Item freigeschalten ist."
L["cmd_help_item_link"]	= format("|c%s%s |c%s%s|r\n", "FFffff00", "/tmt item", "ff1eff00", "[Itemlink]") .. "-- überprüft via Item-Link, ob dieses Item freigeschalten ist."
L["cmd_help_reset"]	= format("|c%s%s|r\n", "FFffff00", "/tmt reset") .. "-- setzt die Datenbank der erfassten Transmog-Aussehen zurück."

L["cmd_howto"]	= "Das Addon zeichnet freigeschaltene Transmog-Aussehen auf.\n    Besuche den |cff66bbffErhabener Illusionist|r NPC und blättere durch alle Seiten, um bereits bekannte Aussehen zu erfassen."

L["cmd_item_error_input"]	= "Eingabe <|cFFffff00%s|r> ist nicht kompatibel für ".. format("|c%s%s|r", "FFffff00", "/tmt item")
L["cmd_item_known_item"]	= "%s ist |cFF00dd00freigeschalten|r."
L["cmd_item_known_visual"]	= "%s ist |cFFffff00unbekannt|r, ist jedoch für %d |4Item:Items des gleichen Aussehens freigeschalten."
L["cmd_item_unknown"]	= "Das Transmog-Aussehen von %s ist |cFFffff00unbekannt|r."

L["cmd_clear_db"]	= "Datenbank wurde zurückgesetzt."

L["cmd_unknown_none"]	= "Eingabe <|cFFffff00%s|r> ist kein bekannter Befehl."
L["cmd_unknown_multiple"]	= "Eingabe <|cFFffff00%s|r> entspricht mehreren Befehlen: |cFFffff00%s|r"

L["tooltip_item_known_item"]	= "|cff66bbffTMT|r: |cFF00dd00freigeschalten|r"
L["tooltip_item_known_visual"]	= "|cff66bbffTMT|r: |cFFffff00unbekannt|r, jedoch Item(s) des gleichen Aussehens freigeschalten"
L["tooltip_item_unknown"]	= "|cff66bbffTMT|r: |cFFffff00unbekannt|r"
