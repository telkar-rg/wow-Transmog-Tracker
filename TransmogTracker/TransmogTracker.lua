local ADDON_NAME, ADDON_TABLE = ...

TransmogTracker = LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceConsole-3.0", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local addon = TransmogTracker


local db


local ADDON_NAME_SHORT = "TMT"

local function DPrint(...)
	-- DEFAULT_CHAT_FRAME:AddMessage( chatprefix..tostring(msg) )
	-- ChatFrame3:AddMessage( head.." "..tostring(table.concat(tmp," !! ",1,n)) )
	DEFAULT_CHAT_FRAME:AddMessage( "|cff33ff99"..ADDON_NAME_SHORT.."|r: " .. strjoin("; ", tostringall(...) ) )
end
local print=DPrint


function addon:OnInitialize()
	-- Code that you want to run when the addon is first loaded goes here.
	print("OnInitialize")
	
	db = LibStub("AceDB-3.0"):New(ADDON_NAME.."_DB")
	db.global = db.global or {}
	
	addon:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function addon:OnEnable()
    -- Called when the addon is enabled
end

function addon:OnDisable()
    -- Called when the addon is disabled
end


function addon:OnSlashCommand(input)
	if input then
		input = strlower(input):trim()
	else
		print("Unknown command.")
	end
	
	if (input == "tmt") then
		
	else
		print("Unknown command.",input)
	end
end


function addon:PLAYER_ENTERING_WORLD()
	
end

