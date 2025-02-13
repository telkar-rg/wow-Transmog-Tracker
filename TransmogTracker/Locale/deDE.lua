local ADDON_NAME, addonTable = ...;

local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "deDE")
if not L then return end

local RED    = "|cFFff8000"
local ORANGE = "|cFFffb000"
local YELLOW = "|cFFffff20"
local BLUE   = "|cFF66bbff"
local GREEN  = GREEN_FONT_COLOR_CODE
local TXT_ILLUSIONIST = BLUE.."Erhabener Illusionist|r"

L["SHARDS_NAME"] = "Splitter der Illusion"
L["CHAT_MSG_SYSTEM_PATTERN"] = "^Freigeschaltetes Aussehen zur Transmogrifizierung: (\124c%x+\124Hitem:(%d+):[:%d]+\124h%[(.-)%]\124h\124r)$"
L["CHAT_MSG_SYSTEM_PATTERN_SOON"] = "^Freigeschaltetes Aussehen zur Transmogrifizierung, sobald die entsprechende Stufe erreicht wurde: (\124c%x+\124Hitem:(%d+):[:%d]+\124h%[(.-)%]\124h\124r)$"
L["MSG_PATTERN_TRACKING"] = "Erfasse %s"

L["NOTIFY_DB_RESET_CMD"] = "Die Addon-Datenbank wurde zurückgesetzt."
L["NOTIFY_DB_RESET_FIRST_TIME"] = "Die Addon-Datenbank ist leer, weil dieses Addon zum ersten Mal geladen wurde oder weil der WTF-Ordner gelöscht wurde."
L["NOTIFY_DB_RESET_VERSION_MISMATCH"] = "Die Addon-Datenbank wurde zurückgesetzt, weil die DB-Version nicht mit dieser Version des Addons übereinstimmte."
L["NOTIFY_DB_EMPTY"] = "Um bereits freigeschaltete Transmog-Aussehen zu erfassen, besuche den "..TXT_ILLUSIONIST.." NPC und blättere durch alle bekannte Aussehen."

L["cmd_help_commands"]  = YELLOW .. "/tmt help"    .. "|r\n" .. "-- Zeigt Liste der Befehle."
L["cmd_help_howto"]	    = YELLOW .. "/tmt howto"   .. "|r\n" .. "-- Erklärt wie man dieses Addon benutzt."
L["cmd_help_item_id"]   = YELLOW .. "/tmt item " .. BLUE .. "ITEMID"     .. "|r\n" .. "-- Überprüft via Item-ID, ob dieses Item freigeschaltet ist."
L["cmd_help_item_link"] = YELLOW .. "/tmt item " .. GREEN .. "[Itemlink]" .. "|r\n" .. "-- Überprüft via Item-Link, ob dieses Item freigeschaltet ist."
L["cmd_help_tooltip"]   = YELLOW .. "/tmt tooltip" .. "|r\n" .. "-- Schaltet Tooltip-Anzeige ein/aus."
L["cmd_help_reset"]	    = YELLOW .. "/tmt reset"   .. "|r\n" ..  "-- Setzt die Datenbank der erfassten Transmog-Aussehen zurück."
L["cmd_help_scan"]      = YELLOW .. "/tmt scan"    .. "|r\n" .. "-- Zeichnet alle freigeschalteten Transmog-Aussehen beim " .. TXT_ILLUSIONIST .. " NPC auf.\nDu musst im " .. BLUE .. "Hauptmenü|r des NPCs sein."

L["cmd_howto"] 	= "Das Addon zeichnet freigeschaltete Transmog-Aussehen auf.\nBesuche den " .. TXT_ILLUSIONIST .. " NPC und blättere durch alle Seiten, um bereits bekannte Aussehen zu erfassen."

L["cmd_item_error_input"]	= "Eingabe <"..YELLOW.."%s|r> ist nicht kompatibel für ".. YELLOW .. "/tmt item" .. "|r"
L["cmd_item_known_item"]	= "%s ist " .. GREEN .. "freigeschaltet|r."
L["cmd_item_known_visual"]	= "%s ist " .. ORANGE .. "unbekannt|r, ist jedoch für %d |4Item:Items; des gleichen Aussehens freigeschaltet."
L["cmd_item_unknown"]	= "Das Transmog-Aussehen von %s ist " .. RED .. "unbekannt|r."

L["cmd_clear_db"]	= "Datenbank dieses Charakters wurde zurückgesetzt."

L["cmd_unknown_none"]	= "FEHLER: Eingabe <" .. YELLOW .. "%s|r> ist kein bekannter Befehl."
L["cmd_unknown_multiple"]	= "FEHLER: Eingabe <" .. YELLOW .. "%s|r> entspricht mehreren Befehlen: " .. YELLOW .. "%s|r"

L["cmd_scan_err_gossip_open"]	= "FEHLER: " .. YELLOW .. "/tmt scan"    .. "|r\n" .. "-- Zeichnet alle freigeschalteten Transmog-Aussehen beim " .. TXT_ILLUSIONIST .. " NPC auf.\nDu musst im " .. BLUE .. "Hauptmenü|r des NPCs sein."
L["cmd_scan_err_timeout"]	= "FEHLER: Scan nach %s Zeitüberschreitung abgebrochen."
L["cmd_scan_finish"]	= "Scan abgeschlossen: %d |4Item:Items; erfasst.\nFür verlässliche Scan-Resultate, folgende Schritte vor dem Scan ausführen:"
L["cmd_scan_finish_1"]	= "1) DB zurücksetzen (" .. YELLOW .. "/tmt reset" .. "|r)"
L["cmd_scan_finish_2"]	= "2) Alle Items ausziehen, welche " .. BLUE .. "derzeit transmogrifiziert sind" .. "|r"
L["cmd_scan_finish_3"]	= "3) Alle " .. YELLOW .. "BoE Items" .. "|r (" .. ITEM_BIND_ON_EQUIP .. ") von den Taschen entfernen (z.B. in die Bank)"

L["tooltip_item_known_item"]	= GREEN .. "freigeschaltet|r"
L["tooltip_item_known_visual"]	= ORANGE .. "für Item(s) gleichen Aussehens freigeschaltet|r"
L["tooltip_item_unknown"]	= RED .. "unbekannt|r"
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
