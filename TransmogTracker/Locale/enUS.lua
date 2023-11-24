local ADDON_NAME, addonTable = ...;

local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "enUS", true)
if not L then return end

L["SHARDS_NAME"] = "Shards of Illusion"
L["CHAT_MSG_SYSTEM_PATTERN"] = "^Unlocked appearance for transmogrification: (\124c%x+\124Hitem:(%d+):[:%d]+\124h%[(.-)%]\124h\124r)$"
L["MSG_PATTERN_TRACKING"] = "Tracking %s"

L["NOTIFY_DB_RESET_CMD"] = "The addon database has been reset."
L["NOTIFY_DB_RESET_FIRST_TIME"] = "The addon database is empty because this is the first time this addon has been loaded or because your WTF folder has been deleted."
L["NOTIFY_DB_RESET_VERSION_MISMATCH"] = "The addon database has been reset because the DB-Version did not match with this version of the addon."
L["NOTIFY_DB_EMPTY"] = "In order to track previously unlocked Transmog appearances, visit the |cff66bbffSublime Illusionist|r NPC and browse through all known appearances."

L["cmd_help_commands"]	= format("|c%s%s|r\n", "FFffff00", "/tmt help") .. "-- shows list of commands."
L["cmd_help_howto"]	= format("|c%s%s|r\n", "FFffff00", "/tmt howto") .. "-- explains how to use this addon."
L["cmd_help_item_id"]	= format("|c%s%s |c%s%s|r\n", "FFffff00", "/tmt item", "ff66bbff", "ITEMID") .. "-- check if you have unlocked an item by its ID."
L["cmd_help_item_link"]	= format("|c%s%s |c%s%s|r\n", "FFffff00", "/tmt item", "ff1eff00", "[Itemlink]") .. "-- check if you have unlocked an item by its Item-Link."
L["cmd_help_reset"]	= format("|c%s%s|r\n", "FFffff00", "/tmt reset") .. "-- clears the database of tracked transmogrification appearances."

L["cmd_howto"]	= "The addon keeps track of unlocks of transmogrification appearances.\n    Visit the |cff66bbffSublime Illusionist|r NPC and browse through all pages, in order to track previously unlocked appearances."

L["cmd_item_error_input"]	= "Input <|cFFffff00%s|r> is not a valid argument for ".. format("|c%s%s|r", "FFffff00", "/tmt item")
L["cmd_item_known_item"]	= "%s is |cFF00dd00unlocked|r."
L["cmd_item_known_visual"]	= "%s is |cFFffff00not known|r, but is unlocked for %d |4item:items of the same appearance."
L["cmd_item_unknown"]	= "The transmogrification appearance of %s is |cFFffff00not known|r."

L["cmd_clear_db"]	= "Database has been reset."

L["cmd_unknown_none"]	= "Input <|cFFffff00%s|r> is not a known command."
L["cmd_unknown_multiple"]	= "Input <|cFFffff00%s|r> matches multiple commands: |cFFffff00%s|r"

L["tooltip_item_known_item"]	= "TMT: |cFF00dd00unlocked|r"
L["tooltip_item_known_visual"]	= "TMT: |cFFffff00not known|r, but unlocked for item(s) of the same appearance"
L["tooltip_item_unknown"]	= "TMT: |cFFffff00not known|r"
