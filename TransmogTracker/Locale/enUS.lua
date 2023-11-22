local ADDON_NAME, addonTable = ...;

local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "enUS", true)
if not L then return end

L["SHARDS_NAME"] = "Shards of Illusion"
L["CHAT_MSG_SYSTEM_PATTERN"] = "^Unlocked appearance for transmogrification: \124c%x+\124Hitem:(%d+):[:%d]+\124h%[(.-)%]\124h\124r$"
L["MSG_PATTERN_TRACKING"] = "Tracking %s"

L["NOTIFY_DB_RESET_CMD"] = "The addon database has been reset."
L["NOTIFY_DB_RESET_FIRST_TIME"] = "The addon database is empty because this is the first time this addon has been loaded or because your WTF folder has been deleted."
L["NOTIFY_DB_RESET_VERSION_MISMATCH"] = "The addon database has been reset because the DB-Version did not match with this version of the addon."
L["NOTIFY_DB_EMPTY"] = "In order to track previously unlocked Transmog appearances, visit the |cff66bbffSublime Illusionist|r NPC and browse through all known appearances."
