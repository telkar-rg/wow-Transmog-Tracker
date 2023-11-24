local ADDON_NAME, ADDON_TABLE = ...

local addon = LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceConsole-3.0", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
_G[ADDON_NAME] = addon

local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)

local ADDON_NAME_SHORT = "TMT"

local DB_Version = 2
local db
-- local playerName = "PLAYER"
-- local TmogNpcGuid = "0xF1300F6D19"
local UniqueDisplay = ADDON_TABLE["UniqueDisplay"]

local pattern_item = "(\124c%x+\124Hitem:(%d+):[:%d]+\124h%[(.-)%]\124h\124r)"
local pattern_link = "(\124c%x+\124H.-\124h\124r)"
local check_gear_flag = true

local TMT_OnShowTooltip -- forward-declaration

local function DPrint(...)
	-- DEFAULT_CHAT_FRAME:AddMessage( chatprefix..tostring(msg) )
	-- ChatFrame3:AddMessage( head.." "..tostring(table.concat(tmp," !! ",1,n)) )
	DEFAULT_CHAT_FRAME:AddMessage( "|cff66bbff"..ADDON_NAME_SHORT.."|r: " .. strjoin("|r; ", tostringall(...) ) )
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
	
	addon:RegisterChatCommand("transmogtracker", "OnSlashCommand")
	addon:RegisterChatCommand("tmt", "OnSlashCommand")

	GameTooltip:HookScript("OnTooltipSetItem", TMT_OnShowTooltip)
	ItemRefTooltip:HookScript("OnTooltipSetItem", TMT_OnShowTooltip)
	if IsAddOnLoaded("AtlasLoot") then
		AtlasLootTooltip:HookScript("OnTooltipSetItem", TMT_OnShowTooltip)
	end
	
	-- addon:RegisterEvent("PLAYER_ENTERING_WORLD")
	addon:RegisterEvent("CHAT_MSG_SYSTEM")
	addon:RegisterEvent("GOSSIP_SHOW")
end


function addon:setupDB()
	-- db = LibStub("AceDB-3.0"):New(ADDON_NAME.."_DB") 
	db = _G[ADDON_NAME.."_CharDB"] or {}
	
	
	if not db.DB_Version or db.DB_Version ~= DB_Version then
		if not db.DB_Version then
			self:ScheduleTimer("notifyResetDB", 20, 1)
		elseif db.DB_Version ~= DB_Version then
			self:ScheduleTimer("notifyResetDB", 20, 2)
		end
		addon:resetDB(true)
	end
	db.ItemIds = db.ItemIds or {}
	db.UniqueDisplayIds = db.UniqueDisplayIds or {}
	
	
	_G[ADDON_NAME.."_CharDB"] = db
end

function addon:resetDB(silent)
	wipe(db)
	
	db.DB_Version = DB_Version
	db.ItemIds = db.ItemIds or {}
	db.UniqueDisplayIds = db.UniqueDisplayIds or {}
	
	if not silent then
		print(L["cmd_clear_db"])
	end
end


function addon:notifyResetDB(reason)
	if reason==1 then
		print( L["NOTIFY_DB_RESET_FIRST_TIME"] )
	elseif reason==2 then
		print( L["NOTIFY_DB_RESET_VERSION_MISMATCH"] )
	else
		print( L["NOTIFY_DB_RESET_CMD"] )
	end
	
	self:ScheduleTimer( function() print( L["NOTIFY_DB_EMPTY"] ) end, 0.5)
end


function addon:OnEnable()
	-- Called when the addon is enabled
end

function addon:OnDisable()
	-- Called when the addon is disabled
end


local cmd_list = {
	commands	= "commands",
	help	= "commands",
	howto	= "howto",
	item	= "item",
	link	= "item",
	-- clear	= "reset",
	reset	= "reset",
}
local function searchCmdList(checkCmd)
	checkCmd = format("^%s", checkCmd)
	local t = {}
	for cmd,cmdFull in pairs(cmd_list) do
		if strfind(cmd, checkCmd) then
			tinsert(t, cmd)
		end
	end
	return t
end
local cmd_list_help = {
	L["cmd_help_commands"],
	L["cmd_help_howto"],
	L["cmd_help_item_id"],
	L["cmd_help_item_link"],
	L["cmd_help_reset"],
}

function addon:OnSlashCommand(input)
	if not input or type(input)~="string" then input="" end
	
	local input_work = input
	local p1,p2, link_found, idx
	local link_table = {}
	local searchLink = true
	
	while searchLink do
		p1,p2 = strfind(input_work, pattern_link)
		if not p1 then
			searchLink=false
		else
			link_found = strsub(input_work,p1,p2)
			tinsert(link_table, link_found)
			input_work = strsub(input_work,1,p1-1) .. format(" \1@%d@ ",#link_table) .. strsub(input_work,p2+1,strlen(input_work))
		end
	end
	
	input_work = gsub(input_work,"[ ]+"," ")
	input_work = strtrim(input_work)
	input_work = strlower(input_work)
	local argsT = { strsplit(" ", input_work) }
	
	for k,a in pairs(argsT) do
		idx = strmatch(a, "\1@(%d+)@")
		if idx then
			argsT[k] = link_table[tonumber(idx)]
		end
	end
	arg1,arg2,arg3 = unpack(argsT)
	
	
	if arg1=="" then
		local _, addon_title = GetAddOnInfo(ADDON_NAME)
		print( format("|cFFffff00%s|r by |cff66bbffTelkar-RG|r\n%s", addon_title, L["cmd_help_commands"]) )
		return
	end
	
	local cmdResults = searchCmdList(arg1)
	if #cmdResults==1 then arg1 = cmd_list[ cmdResults[1] ] end
	
	if arg1 == "commands" then
		for i,cmd_help in pairs(cmd_list_help) do
			self:ScheduleTimer( function() print( cmd_help ) end, i*0.05)
		end
		return
	elseif arg1 == "howto" then
		print(L["cmd_howto"])
		return
	elseif arg1 == "item" then
		addon:cmdCheckItemParse(arg2)
		return
	elseif arg1 == "reset" then
		addon:resetDB()
		return
	else
		if #cmdResults>1 then
			print( format(L["cmd_unknown_multiple"], arg1, strjoin(", ",unpack(cmdResults)) ) )
		else
			print( format(L["cmd_unknown_none"], arg1 ) .."\n".. L["cmd_help_commands"] )
		end
	end
end


function addon:cmdCheckItemParse(input)
	if not input then
		print(L["cmd_help_item_id"])
		print(L["cmd_help_item_link"])
		return
	end
	
	local itemLink, itemId, itemName
	itemId = tonumber(input)
	if not itemId then
		itemLink, itemId, itemName = strmatch( input, pattern_item )
		itemId = tonumber(itemId)
	end
	
	if itemId then
		addon:cmdCheckItemId(itemId)
	else
		print(format( L["cmd_item_error_input"], input) )
		print(L["cmd_help_item_id"])
		print(L["cmd_help_item_link"])
	end
end

function addon:cmdCheckItemId(itemId)
	-- print("--", "addon:cmdCheckItemId(itemId)", itemId)
	
	local _, itemLink = GetItemInfo(itemId)
	if not itemLink then
		itemLink = format("|cff66bbff|Hitem:%d:0:0:0:0:0:0:0:0|h[Item: %d]|h|r", itemId, itemId)
	end
	
	if addon:checkItemId(itemId) then
		print( format(L["cmd_item_known_item"], itemLink) )
		return
	end
	
	local tmogOther = addon:checkUniqueId(itemId)
	if tmogOther then
		local t={}
		for k,_ in pairs(tmogOther) do
			local _, il2 = GetItemInfo(k)
			if not il2 then
				il2 = format("|cff66bbff|Hitem:%d:0:0:0:0:0:0:0:0|h[Item: %d]|h|r", k, k)
			end
			tinsert(t,il2)
		end
		if #t>0 then
			print( format(L["cmd_item_known_visual"], itemLink, #t ) )
			for _,v in pairs(t) do
				print(v)
			end
			return
		end
	end
	
	print( format(L["cmd_item_unknown"], itemLink) )
end


function addon:PLAYER_ENTERING_WORLD()
	-- print( "PLAYER_ENTERING_WORLD" )
	-- playerName = UnitName("player")
end


-- CHAT_MSG_SYSTEM Freigeschaltetes Aussehen zur Transmogrifizierung: !cffffffff!Hitem:2901:0:0:0:0:0:0:0:0!h[Spitzhacke]!h!r
-- local pattern_long = "^Freigeschaltetes Aussehen zur Transmogrifizierung: \124c%x+\124Hitem:(%d+):[:%d]+\124h%[(.-)%]\124h\124r$"


function addon:CHAT_MSG_SYSTEM( event, msg )
	-- print(msg)
	local itemLink, itemId, itemName = strmatch( msg, L["CHAT_MSG_SYSTEM_PATTERN"] )
	if not itemId then return end
	print(itemLink, itemId, itemName)
	
	itemId = tonumber(itemId)
	if not itemId then return end
	
	-- if not db.char.item_ids[itemId] then
		-- print(format("Transmog Tracking: %s", itemName))
	-- end
	addon:setDisplayId(itemId, itemLink)
end


function addon:GOSSIP_SHOW()
	local GossipText = GetGossipText()

	if strfind(GossipText, L["SHARDS_NAME"]) then
		local GossipOptions = { GetGossipOptions() }
		local itemLink, itemId, itemName
		
		for k,line in pairs(GossipOptions) do
			itemLink, itemId, itemName = strmatch( line, pattern_item )
			if itemId then
				itemId = tonumber(itemId)
			end
			if itemId then
				addon:setDisplayId(itemId, itemLink)
			end
		end
		
		if check_gear_flag then
			-- check_gear_flag = false
			addon:checkGearWorn()
		end
	end
end


-- 1 = head
-- 2 = neck
-- 3 = shoulder
-- 4 = shirt
-- 5 = chest
-- 6 = waist
-- 7 = legs
-- 8 = feet
-- 9 = wrist
-- 10 = hands
-- 11 = finger 1
-- 12 = finger 2
-- 13 = trinket 1
-- 14 = trinket 2
-- 15 = back
-- 16 = main hand
-- 17 = off hand
-- 18 = ranged
-- 19 = tabard
local tmog_locations = {
	INVTYPE_HEAD = "HeadSlot",
	INVTYPE_SHOULDER = "ShoulderSlot",
	INVTYPE_CLOAK = "BackSlot",
	INVTYPE_CHEST = "ChestSlot",
	INVTYPE_ROBE = "ChestSlot",
	INVTYPE_BODY = "ShirtSlot",
	INVTYPE_TABARD = "TabardSlot",
	INVTYPE_WRIST = "WristSlot",
	INVTYPE_HAND = "HandsSlot",
	INVTYPE_WAIST = "WaistSlot",
	INVTYPE_LEGS = "LegsSlot",
	INVTYPE_FEET = "FeetSlot",
	INVTYPE_2HWEAPON = "MainHandSlot",
	INVTYPE_WEAPON = "MainHandSlot",
	INVTYPE_WEAPONMAINHAND = "MainHandSlot",
	INVTYPE_WEAPONOFFHAND = "SecondaryHandSlot",
	INVTYPE_RANGED = "MainHandSlot",
	INVTYPE_RANGEDRIGHT = "MainHandSlot",
	INVTYPE_SHIELD = "SecondaryHandSlot",
	INVTYPE_HOLDABLE = "SecondaryHandSlot",
	INVTYPE_THROWN = "MainHandSlot",
}
function addon:checkGearWorn()
	local itemId, itemLink, itemEquipLoc
	for invSlot=0,20,1 do
		itemId = GetInventoryItemID("player", invSlot);
		if itemId then
			_, itemLink, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(itemId)
			if itemEquipLoc and tmog_locations[itemEquipLoc] then
				-- print(invSlot, itemEquipLoc, itemId)
				addon:setDisplayId(itemId, itemLink)
			end
		end
	end
end


function addon:setDisplayId(itemId, itemLink)
	if not db.ItemIds[itemId] then
		if not itemLink then
			itemLink = format("|cff66bbff|Hitem:%d:0:0:0:0:0:0:0:0|h[Item: %d]|h|r", itemId, itemId)
		end
		print(format(L["MSG_PATTERN_TRACKING"], itemLink))
	end
	
	db.ItemIds[itemId] = 1
	if UniqueDisplay[itemId] then
		db.UniqueDisplayIds[UniqueDisplay[itemId]] = db.UniqueDisplayIds[UniqueDisplay[itemId]] or {}
		db.UniqueDisplayIds[UniqueDisplay[itemId]][itemId] = 1
	end
end


function addon:checkItemId(itemId)
	return db.ItemIds[itemId]
end

function addon:checkUniqueId(itemId)
	local uid = UniqueDisplay[itemId]
	if uid then
		return db.UniqueDisplayIds[uid]
	end
	return
end


TMT_OnShowTooltip = function(tooltip) -- has been declared local
	local itemLink, itemId, itemEquipLoc

	_, itemLink = tooltip:GetItem()
	if not itemLink then
		return
	end

	_, itemId = strsplit(":", strmatch(itemLink, "item[%-?%d:]+"))
	itemId = tonumber(itemId)
	_, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(itemId)

	if itemEquipLoc and tmog_locations[itemEquipLoc] then
		local tooltipText
		if addon:checkItemId(itemId) then
			tooltipText = L["tooltip_item_known_item"]
		else
			local tmogOther = addon:checkUniqueId(itemId)
			if tmogOther and next(tmogOther) then
				tooltipText = L["tooltip_item_known_visual"]
			else
				tooltipText = L["tooltip_item_unknown"]
			end
		end
		tooltip:AddLine(tooltipText)
	end
end
