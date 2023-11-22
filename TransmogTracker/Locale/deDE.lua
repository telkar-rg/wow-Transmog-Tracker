local ADDON_NAME, addonTable = ...;

local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "deDE")
if not L then return end

L["SHARDS_NAME"] = "Splitter der Illusion"
L["CHAT_MSG_SYSTEM_PATTERN"] = "^Freigeschaltetes Aussehen zur Transmogrifizierung: \124c%x+\124Hitem:(%d+):[:%d]+\124h%[(.-)%]\124h\124r$"
L["MSG_PATTERN_TRACKING"] = "Erfasse %s"

L["NOTIFY_DB_RESET_CMD"] = "Die Addon-Datenbank wurde zurückgesetzt."
L["NOTIFY_DB_RESET_FIRST_TIME"] = "Die Addon-Datenbank ist leer, weil dieses Addon zum ersten Mal geladen wurde oder weil der WTF-Ordner gelöscht wurde."
L["NOTIFY_DB_RESET_VERSION_MISMATCH"] = "Die Addon-Datenbank wurde zurückgesetzt, weil die DB-Version nicht mit dieser Version des Addons übereinstimmte."
L["NOTIFY_DB_EMPTY"] = "Um bereits freigeschaltene Transmog-Aussehen zu erfassen, besuche den |cff66bbffErhabener Illusionist|r NPC und blättere durch alle bekannte Aussehen."
