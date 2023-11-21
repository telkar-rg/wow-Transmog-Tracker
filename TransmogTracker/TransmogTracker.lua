local ADDON_NAME, ADDON_TABLE = ...

local addon = LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceConsole-3.0", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
_G[ADDON_NAME] = addon


local db
local playerName = "PLAYER"
local TmogNpcGuid = "0xF1300F6D19"
local UniqueDisplay = ADDON_TABLE["UniqueDisplay"]


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
	
	db = LibStub("AceDB-3.0"):New(ADDON_NAME.."_DB")
	-- db.char.CHAT_MSG_SYSTEM = db.char.CHAT_MSG_SYSTEM or {}
	db.char.item_ids = db.char.item_ids or {}
	
	-- addon:RegisterEvent("PLAYER_ENTERING_WORLD")
	addon:RegisterEvent("CHAT_MSG_SYSTEM")
	addon:RegisterEvent("GOSSIP_SHOW")
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
	playerName = UnitName("player")
end


-- CHAT_MSG_SYSTEM Freigeschaltetes Aussehen zur Transmogrifizierung: !cffffffff!Hitem:2901:0:0:0:0:0:0:0:0!h[Spitzhacke]!h!r
local pattern_long  = "^Freigeschaltetes Aussehen zur Transmogrifizierung: \124c%x+\124Hitem:(%d+):[:%d]+\124h%[(.-)%]\124h\124r$"
local pattern_short  = "(\124c%x+\124Hitem:(%d+):[:%d]+\124h%[(.-)%]\124h\124r)"

function addon:CHAT_MSG_SYSTEM( event, msg )
	-- print(msg)
    local itemId, itemName = strmatch( msg, pattern_long )
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

	if strfind(GossipText, "Splitter der Illusion") then
		local GossipOptions = { GetGossipOptions() }
		local itemId, itemName
		
		for k,line in pairs(GossipOptions) do
			itemLink, itemId, itemName = strmatch( line, pattern_short )
			if itemId then
				itemId = tonumber(itemId)
			end
			if itemId then
				if not db.char.item_ids[itemId] then
					print(format("Tracking %s", itemLink))
				end
				
				addon:setDisplayId(itemId)
			end
		end
	end
end


function addon:setDisplayId(itemId)
	db.char.item_ids[itemId] = 1
	if UniqueDisplay[itemId] then
		db.char.item_ids[ UniqueDisplay[itemId] ] = 1
	end
end


function addon:checkItemId(itemId)
	return db.char.item_ids[itemId]
end

