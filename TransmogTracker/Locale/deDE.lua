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

L["cmd_help_commands"]	= format("|c%s%s|r\n", "FFffff00", "/tmt help") .. "-- Zeigt Liste der Befehle."
L["cmd_help_howto"]	= format("|c%s%s|r\n", "FFffff00", "/tmt howto") .. "-- Erklärt wie man dieses Addon benutzt."
L["cmd_help_item_id"]	= format("|c%s%s |c%s%s|r\n", "FFffff00", "/tmt item", "ff66bbff", "ITEMID") .. "-- Überprüft via Item-ID, ob dieses Item freigeschaltet ist."
L["cmd_help_item_link"]	= format("|c%s%s |c%s%s|r\n", "FFffff00", "/tmt item", "ff1eff00", "[Itemlink]") .. "-- Überprüft via Item-Link, ob dieses Item freigeschaltet ist."
L["cmd_help_tooltip"]	= format("|c%s%s|r\n", "FFffff00", "/tmt tooltip") .. "-- Schaltet Tooltip-Anzeige ein/aus."
L["cmd_help_reset"]	= format("|c%s%s|r\n", "FFffff00", "/tmt reset") .. "-- Setzt die Datenbank der erfassten Transmog-Aussehen zurück."
L["cmd_help_scan"]	= format("|c%s%s|r\n", "FFffff00", "/tmt scan") .. "-- Zeichnet alle freigeschalteten Transmog-Aussehen beim |cff66bbffErhabener Illusionist|r NPC auf. " .. format("Du musst im |c%s%s|r des NPCs sein.", "ff66bbff", "Hauptmenü")

L["cmd_howto"]	= "Das Addon zeichnet freigeschaltete Transmog-Aussehen auf.\n    Besuche den |cff66bbffErhabener Illusionist|r NPC und blättere durch alle Seiten, um bereits bekannte Aussehen zu erfassen."

L["cmd_item_error_input"]	= "Eingabe <|cFFffff00%s|r> ist nicht kompatibel für ".. format("|c%s%s|r", "FFffff00", "/tmt item")
L["cmd_item_known_item"]	= "%s ist |cFF00dd00freigeschaltet|r."
L["cmd_item_known_visual"]	= "%s ist |cFFffff00unbekannt|r, ist jedoch für %d |4Item:Items des gleichen Aussehens freigeschaltet."
L["cmd_item_unknown"]	= "Das Transmog-Aussehen von %s ist |cFFffff00unbekannt|r."

L["cmd_clear_db"]	= "Datenbank dieses Charakters wurde zurückgesetzt."

L["cmd_unknown_none"]	= "FEHLER: Eingabe <|cFFffff00%s|r> ist kein bekannter Befehl."
L["cmd_unknown_multiple"]	= "FEHLER: Eingabe <|cFFffff00%s|r> entspricht mehreren Befehlen: |cFFffff00%s|r"

L["cmd_scan_err_gossip_open"]	= "FEHLER: "..format("|c%s%s|r\n", "FFffff00", "/tmt scan") .. "-- Zeichnet alle freigeschalteten Transmog-Aussehen beim |cff66bbffErhabener Illusionist|r NPC auf. " .. format("Du musst im |c%s%s|r des NPCs sein.", "ff66bbff", "Hauptmenü")
L["cmd_scan_err_timeout"]	= "FEHLER: Scan nach %s Zeitüberschreitung abgebrochen."
L["cmd_scan_finish"]	= "Scan abgeschlossen.  " .. "Für verlässlichere Scan-Resultate, führe folgende Schritte vor dem Scan aus:" .. "\n1) DB zurücksetzen (" .. format("|c%s%s|r", "FFffff00", "/tmt reset") .. ")" .. "\n2) Ziehe alle Items aus, welche " .. format("|c%s%s|r", "FFffff00", "derzeit transmogrifiziert sind") .. "\n3) Entferne alle " .. format("|c%s%s|r", "FFffff00", "BoE Items") .. " (" .. ITEM_BIND_ON_EQUIP .. ") von den Taschen (z.B. in die Bank)"

L["tooltip_item_known_item"]	= "|cff1eff00freigeschaltet|r"
L["tooltip_item_known_visual"]	= "|c0cffd200für Item(s) gleichen Aussehens freigeschaltet|r"
L["tooltip_item_unknown"]	= "|cffff2020unbekannt|r"
L["tooltip_cmd_show"]	= "Tooltip-Info wird nun angezeigt."
L["tooltip_cmd_hide"]	= "Tooltip-Info wird nicht mehr angezeigt."
L["tooltip_token_known"]	= "%d |4Item:Items; freigeschaltet: "

L["GOSSIP_TEXT_MAINMENU"] 	= "^%s-%-%- Hauptmenü %-%-\n\n%*%* Gesamte Splitter der Illusion %*%*.+"
L["GOSSIP_TEXT_THISSLOT"] 	= "^%s-%-%- Transmogrifizieren: (.-) %-%-\n\nSplitter der Illusion:"
L["GOSSIP_OPTION_PAGE_PREV"] = "Vorherige Seite"
L["GOSSIP_OPTION_PAGE_NEXT"] = "Nächste Seite"
L["GOSSIP_OPTION_RETURN"] 	= "Zurück..."
L["GOSSIP_OPTION_UPDATE"] 	= "Menü aktualisieren"

L["SLOT_NAME_HEAD"] 		= "Kopf"
L["SLOT_NAME_SHOULDERS"] 	= "Schultern"
L["SLOT_NAME_SHIRT"] 		= "Hemd"
L["SLOT_NAME_CHEST"] 		= "Brust"
L["SLOT_NAME_WAIST"] 		= "Gürtel"
L["SLOT_NAME_LEGS"] 		= "Beine"
L["SLOT_NAME_FEET"] 		= "Füße"
L["SLOT_NAME_WRISTS"] 		= "Handgelenke"
L["SLOT_NAME_HANDS"] 		= "Hände"
L["SLOT_NAME_BACK"] 		= "Rücken"
L["SLOT_NAME_MAIN_HAND"] 	= "Waffenhand"
L["SLOT_NAME_OFF_HAND"] 	= "Schildhand"
L["SLOT_NAME_RANGED"] 		= "Fernkampfwaffe"
L["SLOT_NAME_TABARD"] 		= "Wappenrock"
