local ADDON_NAME, ADDON_TABLE = ...

local addon = LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceConsole-3.0", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
_G[ADDON_NAME] = addon

local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)

local db
-- local playerName = "PLAYER"
-- local TmogNpcGuid = "0xF1300F6D19"
local UniqueDisplay = ADDON_TABLE["UniqueDisplay"]
local DB_Version = 1


local ADDON_NAME_SHORT = "TMT"

local function DPrint(...)
	-- DEFAULT_CHAT_FRAME:AddMessage( chatprefix..tostring(msg) )
	-- ChatFrame3:AddMessage( head.." "..tostring(table.concat(tmp," !! ",1,n)) )
	DEFAULT_CHAT_FRAME:AddMessage( "|cff33ff99"..ADDON_NAME_SHORT.."|r: " .. strjoin("; ", tostringall(...) ) )
end
local print=DPrint


function addon:OnInitialize()
	-- Code that you want to run when the addon is first loaded goes here.
	-- print("OnInitialize")
	
	if GetRealmName() ~= "Rising-Gods" then
		if IsAddOnLoaded(ADDON_NAME) then
			DisableAddOn(ADDON_NAME)
		end
		return
	end
	
	addon:setupDB()
	
	-- addon:RegisterEvent("PLAYER_ENTERING_WORLD")
	addon:RegisterEvent("CHAT_MSG_SYSTEM")
	addon:RegisterEvent("GOSSIP_SHOW")
end


function addon:setupDB()
	-- db = LibStub("AceDB-3.0"):New(ADDON_NAME.."_DB") 
	db = _G[ADDON_NAME.."_CharDB"] or {}
	
	
	if not db.DB_Version or db.DB_Version ~= DB_Version then
		if not db.DB_Version then
			self:ScheduleTimer("notifyResetDB", 60, 1)
		elseif db.DB_Version ~= DB_Version then
			self:ScheduleTimer("notifyResetDB", 60, 2)
		end
		wipe(db)
		db.DB_Version = DB_Version
	end
	db.ItemIds = db.ItemIds or {}
	db.UniqueDisplayIds = db.UniqueDisplayIds or {}
	
	
	_G[ADDON_NAME.."_CharDB"] = db
end


function addon:notifyResetDB(reason)
	if reason==1 then
		print( L["NOTIFY_DB_RESET_FIRST_TIME"] )
	elseif reason==2 then
		print( L["NOTIFY_DB_RESET_VERSION_MISMATCH"] )
	else
		print( L["NOTIFY_DB_RESET_CMD"] )
	end
	
	print( L["NOTIFY_DB_EMPTY"] )
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
	-- print( "PLAYER_ENTERING_WORLD" )
	-- playerName = UnitName("player")
end


-- CHAT_MSG_SYSTEM Freigeschaltetes Aussehen zur Transmogrifizierung: !cffffffff!Hitem:2901:0:0:0:0:0:0:0:0!h[Spitzhacke]!h!r
-- local pattern_long  = "^Freigeschaltetes Aussehen zur Transmogrifizierung: \124c%x+\124Hitem:(%d+):[:%d]+\124h%[(.-)%]\124h\124r$"
local pattern_short  = "(\124c%x+\124Hitem:(%d+):[:%d]+\124h%[(.-)%]\124h\124r)"

function addon:CHAT_MSG_SYSTEM( event, msg )
	-- print(msg)
    local itemId, itemName = strmatch( msg, L["CHAT_MSG_SYSTEM_PATTERN"] )
	if not itemId then return end
	
	itemId = tonumber(itemId)
	if not itemId then return end
	
	-- if not db.char.item_ids[itemId] then
		-- print(format("Transmog Tracking: %s", itemName))
	-- end
	addon:setDisplayId(itemId)
end


function addon:GOSSIP_SHOW()
	local GossipText = GetGossipText()

	if strfind(GossipText, L["SHARDS_NAME"]) then
		local GossipOptions = { GetGossipOptions() }
		local itemId, itemName
		
		for k,line in pairs(GossipOptions) do
			itemLink, itemId, itemName = strmatch( line, pattern_short )
			if itemId then
				itemId = tonumber(itemId)
			end
			if itemId then
				if not addon:checkItemId(itemId) then
					print(format("Tracking %s", itemLink))
				end
				
				addon:setDisplayId(itemId)
			end
		end
	end
end


function addon:setDisplayId(itemId)
	db.ItemIds[itemId] = 1
	if UniqueDisplay[itemId] then
		db.UniqueDisplayIds[ UniqueDisplay[itemId] ] = 1
	end
end


function addon:checkItemId(itemId)
	return db.ItemIds[itemId]
end

