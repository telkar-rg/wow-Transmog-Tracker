----------------------------------------
-- Created by
	-- Telkar
--
-- Tested by
	-- Phint
--
-- Contributions by
	-- Mat2095
----------------------------------------


local ADDON_NAME, ADDON_TABLE = ...

local addon = LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
_G[ADDON_NAME] = addon

local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)

local ADDON_NAME_SHORT = "TMT"

local DB_Version = 2
local db, dbOptions, dbGlobal

local UniqueDisplay = ADDON_TABLE["UniqueDisplay"]
local TokenInfo = ADDON_TABLE["TokenInfo"]

local pattern_item = "(\124c%x+\124Hitem:(%d+):[:%d]+\124h%[(.-)%]\124h\124r)"
local pattern_link = "(\124c%x+\124H.-\124h\124r)"
local pattern_icon = "\124T.-\124t(.+)"
-- local check_gear_flag = true
local GossipOpen = false
local scan_in_progress = false
local TIMER_SCAN_TIMEOUT
local SCAN_TIMEOUT_TIME = 2
local scan_last
local scan_table_slots = {}
local scan_table_slots_template = { L["SLOT_NAME_HEAD"], L["SLOT_NAME_SHOULDERS"], L["SLOT_NAME_SHIRT"], L["SLOT_NAME_CHEST"], L["SLOT_NAME_WAIST"], L["SLOT_NAME_LEGS"], L["SLOT_NAME_FEET"], L["SLOT_NAME_WRISTS"], L["SLOT_NAME_HANDS"], L["SLOT_NAME_BACK"], L["SLOT_NAME_MAIN_HAND"], L["SLOT_NAME_OFF_HAND"], L["SLOT_NAME_RANGED"], L["SLOT_NAME_TABARD"] }

local TMT_OnShowTooltip -- forward-declaration
local TMT_GroupLootFrame_OpenNewFrame
local TMT_GroupLootFrame_OnShow

local PlayerFaction, PlayerClass

local function DPrint(...)
	-- DEFAULT_CHAT_FRAME:AddMessage( chatprefix..tostring(msg) )
	-- ChatFrame3:AddMessage( head.." "..tostring(table.concat(tmp," !! ",1,n)) )
	DEFAULT_CHAT_FRAME:AddMessage( "|cff66bbff"..ADDON_NAME_SHORT.."|r: " .. strjoin("|r; ", tostringall(...) ) )
	ChatFrame3:AddMessage( "|cff66bbff"..ADDON_NAME_SHORT.."|r: " .. strjoin("|r; ", tostringall(...) ) )
end
local print=DPrint


function addon:OnInitialize()
	-- Code that you want to run when the addon is first loaded goes here.
	-- print("OnInitialize")
	
	
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
	addon:RegisterEvent("GOSSIP_CLOSED")
	
	PlayerFaction = UnitFactionGroup("player") 	-- get EN PlayerFaction
	_, PlayerClass = UnitClass("player") 		-- get EN PlayerClass
	

-- hooksecurefunc("GroupLootFrame_OnShow", TMT_GroupLootFrame_OnShow); -- Hooks the global CastSpellByName
hooksecurefunc("GroupLootFrame_OpenNewFrame", TMT_GroupLootFrame_OpenNewFrame);
-- hooksecurefunc("GroupLootFrame_OnShow", function() print('x') end )
hooksecurefunc("GroupLootFrame_OnHide", TMT_GroupLootFrame_OnHide);
end


function addon:setupDB()
	-- SavedVariablesPerCharacter
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
	
	
	-- SavedVariables
	local defaults = {
		global = {
			options = {
				showTooltip = true,
			},
		},
	}
	dbGlobal = LibStub("AceDB-3.0"):New(ADDON_NAME.."_DB", defaults)
	dbOptions = dbGlobal.global.options
end

function addon:resetDB(silent)
	local hideTooltip = db.hideTooltip
	wipe(db)
	
	db.hideTooltip = hideTooltip
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
	tooltip	= "tooltip",
	reset	= "reset",
	scan	= "scan",
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
	L["cmd_help_tooltip"],
	L["cmd_help_reset"],
	L["cmd_help_scan"],
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
	elseif arg1 == "tooltip" then
		addon:cmdTooltipToggle()
		return
	elseif arg1 == "scan" then
		addon:cmdScanStart()
		return
	else
		if #cmdResults>1 then
			print( format(L["cmd_unknown_multiple"], arg1, strjoin(", ",unpack(cmdResults)) ) )
		else
			print( format(L["cmd_unknown_none"], arg1 ) .."\n".. L["cmd_help_commands"] )
		end
	end
end


function addon:cmdScanTimeout()
	print( format( L["cmd_scan_err_timeout"], SecondsToTime(SCAN_TIMEOUT_TIME) ) )
	addon:cmdScanStop()
end


function addon:cmdScanStopNormal()
	print( L["cmd_scan_finish"] )
	addon:cmdScanStop()
end


function addon:cmdScanStop()
	scan_in_progress = nil
	scan_last = nil
	self:CancelTimer( TIMER_SCAN_TIMEOUT ) 	-- Cancel timeout timer
	TIMER_SCAN_TIMEOUT = nil
end


function addon:cmdScanStart()
	if scan_in_progress then
		print("ERROR: Scan in progress!")
		return
	end
	
	local GossipOptions = { GetGossipOptions() } 
	
	if not GossipOpen then
		-- ERROR gossip menu MUST be open
		print(L["cmd_scan_err_gossip_open"])
		return
	else
		-- check if in main menu
		local GossipText = GetGossipText()
		local isMain = strfind(GossipText,  L["GOSSIP_TEXT_MAINMENU"])
		
		if not isMain then
			-- ERROR gossip menu MUST be at the Transmog NPC and in main menu
			print(L["cmd_scan_err_gossip_open"])
			return
		else
			scan_in_progress = true 	-- set Scan flag to true
			-- TIMER_SCAN_TIMEOUT
			
			self:CancelTimer( TIMER_SCAN_TIMEOUT ) 	-- Cancel timeout timer
			TIMER_SCAN_TIMEOUT = self:ScheduleTimer( "cmdScanTimeout", SCAN_TIMEOUT_TIME) 	-- 2 second timeout timer
			-- self:ScheduleTimer("notifyResetDB", 20, 1)
			
			
			-- check all Labels in GossipOptions of "main menu"
			for k,v in pairs(GossipOptions) do
				local optionText
				
				if k%2==1 then 	-- only check the odd entries (those are the "labels")
					optionText = strmatch(v, pattern_icon) 	-- fetch option text without the Icon in front
					
					-- we try to "Update menu"
					if optionText and optionText==L["GOSSIP_OPTION_UPDATE"] then
						
						-- "true" GossipOption index is half of the "bankier" option (which is k+1)
						SelectGossipOption( (k+1)/2 )
						return
					end
				end
				
			end
		end
	end
end

function addon:cmdTooltipToggle()
	db.hideTooltip = not db.hideTooltip
	if not db.hideTooltip then
		print( L["tooltip_cmd_show"] )
	else
		print( L["tooltip_cmd_hide"] )
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


function addon:CHAT_MSG_SYSTEM( event, msg )
	-- print(msg)
	
	-- Check if MSG is "visual unlocked"
	local itemLink, itemId, itemName = strmatch( msg, L["CHAT_MSG_SYSTEM_PATTERN"] )
	
	if not itemId then
		-- Check if MSG is "visual unlocked soon"
		itemLink, itemId, itemName = strmatch( msg, L["CHAT_MSG_SYSTEM_PATTERN_SOON"] )
	end
	
	if not itemId then return end
	-- print(itemLink, itemId, itemName)
	local _, itemLink2 = GetItemInfo(itemId)
	if itemLink2 then
		itemLink = itemLink2
	end
	
	itemId = tonumber(itemId)
	if not itemId then return end
	
	-- if not db.char.item_ids[itemId] then
		-- print(format("Transmog Tracking: %s", itemName))
	-- end
	
	addon:setDisplayId(itemId, itemLink, true)
	-- self:ScheduleTimer( function() addon:setDisplayId(itemId, itemLink) end, 0.25)
	-- addon:setDisplayId(itemId, itemLink)
end


function addon:GOSSIP_CLOSED()
	GossipOpen = false
end


function addon:GOSSIP_SHOW()
	GossipOpen = true
	
	local GossipText = GetGossipText()
	local isMain = strfind(GossipText,  L["GOSSIP_TEXT_MAINMENU"])
	local isSlot = strmatch(GossipText, L["GOSSIP_TEXT_THISSLOT"])

	if isMain then 	-- if gossip == main menu
		
		-- we are scanning right now
		if scan_in_progress then
			self:CancelTimer( TIMER_SCAN_TIMEOUT ) 	-- Cancel timeout timer
			TIMER_SCAN_TIMEOUT = self:ScheduleTimer( "cmdScanTimeout", SCAN_TIMEOUT_TIME) 	-- 2 second timeout timer
			
			local GossipOptions = { GetGossipOptions() }
			
			if not scan_last then 	-- this is our first call of the scan!
				-- generate fresh table of item slots to check for
				wipe(scan_table_slots)
				for k,v in pairs(scan_table_slots_template) do
					scan_table_slots[v] = 1
				end
			end
			
			-- check all Labels in GossipOptions of "main menu"
			for k,v in pairs(GossipOptions) do
				local optionText
				
				if k%2==1 then 	-- only check the odd entries (those are the "labels")
					optionText = strmatch(v, pattern_icon) 	-- fetch option text without the Icon in front
					
					-- if we detect that "option text" is one of the scan_table_slots
					if optionText and scan_table_slots[optionText] then
						scan_last = optionText
						scan_table_slots[optionText] = nil
						
						-- "true" GossipOption index is half of the "bankier" option (which is k+1)
						SelectGossipOption( (k+1)/2 )
						return
					end
				end
				
			end
			
			-- if we get here: STOP SCANNING
			addon:cmdScanStopNormal()
			return
			
		else 	-- we are NOT scanning
			-- check worn gear on enter of main menu
			addon:checkGearWorn()
		end
	
	elseif isSlot then
		local GossipOptions = { GetGossipOptions() }
		local itemLink, itemId, itemName
		
		-- check shown items (whether we are in scan mode or not)
		for k,line in pairs(GossipOptions) do
			itemLink, itemId, itemName = strmatch( line, pattern_item )
			if itemId then
				itemId = tonumber(itemId)
			end
			if itemId then
				addon:setDisplayId(itemId, itemLink)
			end
		end
		
		-- we are scanning right now
		if scan_in_progress then
			self:CancelTimer( TIMER_SCAN_TIMEOUT ) 	-- Cancel timeout timer
			TIMER_SCAN_TIMEOUT = self:ScheduleTimer( "cmdScanTimeout", SCAN_TIMEOUT_TIME) 	-- 2 second timeout timer
			
			local idx_next, idx_return
			
			-- check all Labels in GossipOptions of "Slot menu"
			for k,v in pairs(GossipOptions) do
				local optionText
				
				if k%2==1 then 	-- only check the odd entries (those are the "labels")
					optionText = strmatch(v, pattern_icon) 	-- fetch option text without the Icon in front
					
					-- if we detect "Next Page" in the optionText, then fetch next page
					if optionText and optionText == L["GOSSIP_OPTION_PAGE_NEXT"] then
						idx_next = (k+1)/2 	-- "true" GossipOption index is half of the "bankier" option (which is k+1)
					end
					-- else: we try return
					if optionText and optionText == L["GOSSIP_OPTION_RETURN"] then
						idx_return = (k+1)/2 
					end
				end
			end
			
			if idx_next then 	-- if we can go to next page
				SelectGossipOption(idx_next)
				return
			end
			if idx_return then 	-- if we can return
				SelectGossipOption(idx_return)
				return
			end
			-- if we get here: we have failed to get to "next page" or to "return"!
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


function addon:setDisplayId(itemId, itemLink, delay)
	if not db.ItemIds[itemId] then
		if not itemLink then
			local _, itemLink = GetItemInfo(itemId)
		end
		if not itemLink then
			itemLink = format("|cff66bbff|Hitem:%d:0:0:0:0:0:0:0:0|h[Item: %d]|h|r", itemId, itemId)
		end
		if delay then
			self:ScheduleTimer( function() print(format(L["MSG_PATTERN_TRACKING"], itemLink)) end, 0)
		else
			print(format(L["MSG_PATTERN_TRACKING"], itemLink))
		end
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
	if db.hideTooltip then return end
	local itemLink, itemId, itemEquipLoc

	_, itemLink = tooltip:GetItem()
	if not itemLink then
		return
	end

	_, itemId = strsplit(":", strmatch(itemLink, "item[%-?%d:]+"))
	itemId = tonumber(itemId)
	if not itemId then return end
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
				-- tooltipText = L["tooltip_item_unknown"] -- dont spam
			end
		end
		if tooltipText then
			tooltipText = format("|cFF66BBFFTMT|r: %s", tooltipText)
			tooltip:AddLine(tooltipText,1,1,1,1)	-- turned on line wrap
		end
		
	elseif TokenInfo[itemId] then
		local tooltipText
		local TokenEntry = TokenInfo[itemId]
		
		-- try faction
		if TokenEntry[PlayerFaction] then
			TokenEntry = TokenEntry[PlayerFaction]
		end
		
		-- try player class
		if TokenEntry[PlayerClass] then
			TokenEntry = TokenEntry[PlayerClass]
		
		-- try ALL category
		elseif TokenEntry["ALL"] then
			TokenEntry = TokenEntry["ALL"]
		end
		
		if not TokenEntry then return end
		
		-- print("-- DEBUG",itemId)
		local knownPurchases = {}
		for k,v in pairs(TokenEntry) do
			-- print(k,v)
			if addon:checkItemId(k) then
				tinsert(knownPurchases, k)
			end
		end
		sort(knownPurchases)
		
		for k,v in pairs(knownPurchases) do 	-- alternate color for unlocked ids
			if k%2==1 then
				knownPurchases[k] = "|cFFffff80" .. tostring(v) .. "|r"
			else
				knownPurchases[k] = "|cFF80ff80" .. tostring(v) .. "|r"
			end
		end
		
		if #knownPurchases > 0 then
			tooltipText = format(L["tooltip_token_known"], #knownPurchases) .. "|cFFFFBB00" .. strjoin(", ", unpack(knownPurchases) ) .. "|r"
		end
		if tooltipText then
			tooltipText = format("\n|cFF66BBFFTMT|r: %s", tooltipText)
			tooltip:AddLine(tooltipText,1,1,1,1)	-- turned on line wrap
		end
	end
end

function TMT_GroupLootFrame_OpenNewFrame(rollID, rollTime)
	-- local texture, name, count, quality = GetLootRollItemInfo(this.rollID);
	print("-- TMT_GroupLootFrame_OpenNewFrame", rollID)
	-- getglobal("TMT_GroupLootFrame"..id.."Texture"):Show();
	
	local frame, idx;
	for i=1, NUM_GROUP_LOOT_FRAMES do
		frame = _G["GroupLootFrame"..i];
		if ( frame:IsShown() and frame.rollID == rollID) then
			idx = i
			break;
		end
	end
	if not idx then return end
	if idx ~= 1 then return end
	
	TMT_GroupLootFrame1:Show()
	
	
	-- local texture = frame.TMT_Icon 
	-- if not texture then 
		-- frame.TMT_Icon = frame:CreateTexture(nil, 'HIGHLIGHT')
		-- texture = frame.TMT_Icon
		
		-- texture:SetTexture("Interface\Icons\INV_Box_01")
		-- texture:SetSize(48, 48)
		-- texture:SetPoint("TOPLEFT", -24, 24);
	-- end
	-- frame:SetTexture("Interface\Icons\INV_Box_01")
	-- frame:Show()
	-- _G["GroupLootFrame" .. i]:Show()
	-- texture:Show()

end
function TMT_GroupLootFrame_OnHide(self)
	print("-- TMT_GroupLootFrame_OnHide", "rollID", self.rollID, "id", self:GetID())

end

function TMT_GroupLootFrame_OnShow(self)
	local rollID = self.rollID
	
	local id = self:GetID();
	-- _G["GroupLootFrame"..id.."IconFrameIcon"]:SetTexture(texture);
	-- _G["GroupLootFrame"..id.."Name"]:SetText(name);
	-- local color = ITEM_QUALITY_COLORS[quality];
	-- _G["GroupLootFrame"..id.."Name"]:SetVertexColor(color.r, color.g, color.b);
	-- if ( count > 1 ) then
		-- _G["GroupLootFrame"..id.."IconFrameCount"]:SetText(count);
		-- _G["GroupLootFrame"..id.."IconFrameCount"]:Show();
	-- else
		-- _G["GroupLootFrame"..id.."IconFrameCount"]:Hide();
	-- end
	
	
	
	print("-- TMT_GroupLootFrame_OnShow","rollID", rollID, "id", id)
	-- getglobal("TMT_GroupLootFrame"..id.."Texture"):Show();
	

end
