local ADDON_NAME, addonTable = ...;

local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "enUS", true)
if not L then return end

L["SHARDS_NAME"] = "Shards of Illusion"
L["CHAT_MSG_SYSTEM_PATTERN"] = "^Unlocked appearance for transmogrification: (\124c%x+\124Hitem:(%d+):[:%d]+\124h%[(.-)%]\124h\124r)$"
L["CHAT_MSG_SYSTEM_PATTERN_SOON"] = "^Unlocked visual for transmogrification once the corresponding level has been reached: (\124c%x+\124Hitem:(%d+):[:%d]+\124h%[(.-)%]\124h\124r)$"
L["MSG_PATTERN_TRACKING"] = "Tracking %s"

L["NOTIFY_DB_RESET_CMD"] = "The addon database has been reset."
L["NOTIFY_DB_RESET_FIRST_TIME"] = "The addon database is empty because this is the first time this addon has been loaded or because your WTF folder has been deleted."
L["NOTIFY_DB_RESET_VERSION_MISMATCH"] = "The addon database has been reset because the DB-Version did not match with this version of the addon."
L["NOTIFY_DB_EMPTY"] = "In order to track previously unlocked Transmog appearances, visit the |cff66bbffSublime Illusionist|r NPC and browse through all known appearances."

L["cmd_help_commands"]	= format("|c%s%s|r\n", "FFffff00", "/tmt help") .. "-- Shows list of commands."
L["cmd_help_howto"]	= format("|c%s%s|r\n", "FFffff00", "/tmt howto") .. "-- Explains how to use this addon."
L["cmd_help_item_id"]	= format("|c%s%s |c%s%s|r\n", "FFffff00", "/tmt item", "ff66bbff", "ITEMID") .. "-- Check if you have unlocked an item by its ID."
L["cmd_help_item_link"]	= format("|c%s%s |c%s%s|r\n", "FFffff00", "/tmt item", "ff1eff00", "[Itemlink]") .. "-- Check if you have unlocked an item by its Item-Link."
L["cmd_help_tooltip"]	= format("|c%s%s|r\n", "FFffff00", "/tmt tooltip") .. "-- Toggles tooltip display."
L["cmd_help_reset"]	= format("|c%s%s|r\n", "FFffff00", "/tmt reset") .. "-- Clears the database of tracked transmogrification appearances."
L["cmd_help_scan"]	= format("|c%s%s|r\n", "FFffff00", "/tmt scan") .. "-- Scans all known appearances at the |cff66bbffSublime Illusionist|r NPC. " .. format("You must be in the |c%s%s|r of the NPC.", "ff66bbff", "Main Menu")

L["cmd_howto"]	= "The addon keeps track of unlocks of transmogrification appearances.\n    Visit the |cff66bbffSublime Illusionist|r NPC and browse through all pages, in order to track previously unlocked appearances."

L["cmd_item_error_input"]	= "Input <|cFFffff00%s|r> is not a valid argument for ".. format("|c%s%s|r", "FFffff00", "/tmt item")
L["cmd_item_known_item"]	= "%s is |cFF00dd00unlocked|r."
L["cmd_item_known_visual"]	= "%s is |cFFffff00not known|r, but is unlocked for %d |4item:items of the same appearance."
L["cmd_item_unknown"]	= "The transmogrification appearance of %s is |cFFffff00not known|r."

L["cmd_clear_db"]	= "Database of this character has been reset."

L["cmd_unknown_none"]	= "ERROR: Input <|cFFffff00%s|r> is not a known command."
L["cmd_unknown_multiple"]	= "ERROR: Input <|cFFffff00%s|r> matches multiple commands: |cFFffff00%s|r"

L["cmd_scan_err_gossip_open"]	= "ERROR: " .. format("|c%s%s|r\n", "FFffff00", "/tmt scan") .. "-- Scans all known appearances at the |cff66bbffSublime Illusionist|r NPC. " .. format("You must be in the |c%s%s|r of the NPC.", "ff66bbff", "Main Menu")
L["cmd_scan_err_timeout"]	= "ERROR: Scan cancelled after %s timeout."
L["cmd_scan_finish"]	= "Scan completed.  " .. "For the most reliable scan results, follow these steps before scanning:" .. "\n1) reset the DB (" .. format("|c%s%s|r", "FFffff00", "/tmt reset") .. ")" .. "\n2) unequip all items that are " .. format("|c%s%s|r", "FFffff00", "currently transmogrified") .. "\n3) remove all " .. format("|c%s%s|r", "FFffff00", "BoE items") .. " (" .. ITEM_BIND_ON_EQUIP .. ") from bags (e.g. to bank)"

L["tooltip_item_known_item"]	= "|cff1eff00unlocked|r"
L["tooltip_item_known_visual"]	= "|c0cffd200unlocked for item(s) of same appearance|r"
L["tooltip_item_unknown"]	= "|cffff2020unknown|r"
L["tooltip_cmd_show"]	= "Tooltip information is now shown."
L["tooltip_cmd_hide"]	= "Tooltip information is now hidden."
L["tooltip_token_known"]	= "%d |4item:items; unlocked: "

L["GOSSIP_TEXT_MAINMENU"] 	= "^%s-%-%- Main Menu %-%-\n\n%*%* Total Shards of Illusion %*%*.+"
L["GOSSIP_TEXT_THISSLOT"] 	= "^%s-%-%- Transmogrify: (.-) %-%-\n\nShards of Illusion:"
L["GOSSIP_OPTION_PAGE_PREV"] = "Previous page"
L["GOSSIP_OPTION_PAGE_NEXT"] = "Next page"
L["GOSSIP_OPTION_RETURN"] 	= "Back..."
L["GOSSIP_OPTION_UPDATE"] 	= "Update menu"

L["SLOT_NAME_HEAD"] 		= "Head"
L["SLOT_NAME_SHOULDERS"] 	= "Shoulders"
L["SLOT_NAME_SHIRT"] 		= "Shirt"
L["SLOT_NAME_CHEST"] 		= "Chest"
L["SLOT_NAME_WAIST"] 		= "Waist"
L["SLOT_NAME_LEGS"] 		= "Legs"
L["SLOT_NAME_FEET"] 		= "Feet"
L["SLOT_NAME_WRISTS"] 		= "Wrists"
L["SLOT_NAME_HANDS"] 		= "Hands"
L["SLOT_NAME_BACK"] 		= "Back"
L["SLOT_NAME_MAIN_HAND"] 	= "Main Hand"
L["SLOT_NAME_OFF_HAND"] 	= "Off Hand"
L["SLOT_NAME_RANGED"] 		= "Ranged"
L["SLOT_NAME_TABARD"] 		= "Tabard"
