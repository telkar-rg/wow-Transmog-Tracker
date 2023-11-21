local ADDON_NAME, addonTable = ...;

local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "enUS", true)
if not L then return end

L["SHARDS_NAME"] = "Shards of Illusion"
L["CHAT_MSG_SYSTEM_PATTERN"] = "^Freigeschaltetes Aussehen zur Transmogrifizierung: \124c%x+\124Hitem:(%d+):[:%d]+\124h%[(.-)%]\124h\124r$" -- needs review
