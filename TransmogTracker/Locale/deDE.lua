local ADDON_NAME, addonTable = ...;

local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "deDE")
if not L then return end

L["SHARDS_NAME"] = "Splitter der Illusion"
L["CHAT_MSG_SYSTEM_PATTERN"] = "^Freigeschaltetes Aussehen zur Transmogrifizierung: (\124c%x+\124Hitem:(%d+):[:%d]+\124h%[(.-)%]\124h\124r)$"
L["CHAT_MSG_SYSTEM_PATTERN_SOON"] = "^Freigeschaltetes Aussehen zur Transmogrifizierung, sobald die entsprechende Stufe erreicht wurde: (\124c%x+\124Hitem:(%d+):[:%d]+\124h%[(.-)%]\124h\124r)$"
L["MSG_PATTERN_TRACKING"] = "Erfasse %s"

L["NOTIFY_DB_RESET_CMD"] = "Die Addon-Datenbank wurde zurückgesetzt."
L["NOTIFY_DB_RESET_FIRST_TIME"] = "Die Addon-Datenbank ist leer, weil dieses Addon zum ersten Mal geladen wurde oder weil der WTF-Ordner gelöscht wurde."
L["NOTIFY_DB_RESET_VERSION_MISMATCH"] = "Die Addon-Datenbank wurde zurückgesetzt, weil die DB-Version nicht mit dieser Version des Addons übereinstimmte."
L["NOTIFY_DB_EMPTY"] = "Um bereits freigeschaltete Transmog-Aussehen zu erfassen, besuche den |cff66bbffErhabener Illusionist|r NPC und blättere durch alle bekannte Aussehen."

L["cmd_help_commands"]	= format("|c%s%s|r\n", "FFffff00", "/tmt help") .. "-- zeigt Liste der Befehle."
L["cmd_help_howto"]	= format("|c%s%s|r\n", "FFffff00", "/tmt howto") .. "-- erklärt wie man dieses Addon benutzt."
L["cmd_help_item_id"]	= format("|c%s%s |c%s%s|r\n", "FFffff00", "/tmt item", "ff66bbff", "ITEMID") .. "-- überprüft via Item-ID, ob dieses Item freigeschaltet ist."
L["cmd_help_item_link"]	= format("|c%s%s |c%s%s|r\n", "FFffff00", "/tmt item", "ff1eff00", "[Itemlink]") .. "-- überprüft via Item-Link, ob dieses Item freigeschaltet ist."
L["cmd_help_tooltip"]	= format("|c%s%s|r\n", "FFffff00", "/tmt tooltip") .. "-- schaltet Tooltip-Anzeige ein/aus."
L["cmd_help_reset"]	= format("|c%s%s|r\n", "FFffff00", "/tmt reset") .. "-- setzt die Datenbank der erfassten Transmog-Aussehen zurück."

L["cmd_howto"]	= "Das Addon zeichnet freigeschaltete Transmog-Aussehen auf.\n    Besuche den |cff66bbffErhabener Illusionist|r NPC und blättere durch alle Seiten, um bereits bekannte Aussehen zu erfassen."

L["cmd_item_error_input"]	= "Eingabe <|cFFffff00%s|r> ist nicht kompatibel für ".. format("|c%s%s|r", "FFffff00", "/tmt item")
L["cmd_item_known_item"]	= "%s ist |cFF00dd00freigeschaltet|r."
L["cmd_item_known_visual"]	= "%s ist |cFFffff00unbekannt|r, ist jedoch für %d |4Item:Items des gleichen Aussehens freigeschaltet."
L["cmd_item_unknown"]	= "Das Transmog-Aussehen von %s ist |cFFffff00unbekannt|r."

L["cmd_clear_db"]	= "Datenbank dieses Charakters wurde zurückgesetzt."

L["cmd_unknown_none"]	= "Eingabe <|cFFffff00%s|r> ist kein bekannter Befehl."
L["cmd_unknown_multiple"]	= "Eingabe <|cFFffff00%s|r> entspricht mehreren Befehlen: |cFFffff00%s|r"

L["tooltip_item_known_item"]	= "|cff1eff00freigeschaltet|r"
L["tooltip_item_known_visual"]	= "|c0cffd200für Item(s) gleichen Aussehens freigeschaltet|r"
L["tooltip_item_unknown"]	= "|cffff2020unbekannt|r"
L["tooltip_cmd_show"]	= "Tooltip-Info wird nun angezeigt."
L["tooltip_cmd_hide"]	= "Tooltip-Info wird nicht mehr angezeigt."
