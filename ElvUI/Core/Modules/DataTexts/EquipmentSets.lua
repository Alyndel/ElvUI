local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule('DataTexts')

local format = format
local tinsert = tinsert
local strjoin = strjoin
local pairs = pairs
local wipe = wipe

local C_EquipmentSet_GetEquipmentSetIDs = C_EquipmentSet.GetEquipmentSetIDs
local C_EquipmentSet_GetEquipmentSetInfo = C_EquipmentSet.GetEquipmentSetInfo
local C_EquipmentSet_UseEquipmentSet = C_EquipmentSet.UseEquipmentSet

local eqSets = {}
local displayString, db = ''

local function OnEnter()
	DT.tooltip:ClearLines()

	DT.tooltip:AddLine('Equipment Sets')
	DT.tooltip:AddLine(' ')

	for _, set in pairs(eqSets) do
		DT.tooltip:AddLine(set.text, set.isEquipped and .2 or 1, set.isEquipped and 1 or .2, .2)
	end

	DT.tooltip:Show()
end

local function OnClick(self)
	E:SetEasyMenuAnchor(E.EasyMenu, self)
	E:ComplicatedMenu(eqSets, E.EasyMenu, nil, nil, nil, 'MENU')
end

local function OnEvent(self, event)
	if event == 'ELVUI_FORCE_UPDATE' or event == 'EQUIPMENT_SETS_CHANGED' then
		wipe(eqSets)
	end

	local activeSetIndex
	for i, setID in pairs(C_EquipmentSet_GetEquipmentSetIDs()) do
		local name, iconFileID, _, isEquipped = C_EquipmentSet_GetEquipmentSetInfo(setID)

		if event == 'ELVUI_FORCE_UPDATE' or event == 'EQUIPMENT_SETS_CHANGED' then
			tinsert(eqSets, { text = format('|T%s:14:14:0:0:64:64:4:60:4:60|t  %s', iconFileID, name), checked = isEquipped, func = function() C_EquipmentSet_UseEquipmentSet(setID) end, setID = setID, name = name, iconFileID = iconFileID, isEquipped = isEquipped })
		end

		if isEquipped then
			activeSetIndex = i
		end
	end

	local set = eqSets[activeSetIndex]
	if not activeSetIndex then
		self.text:SetText('No Set Equipped')
	elseif set then
		if db.NoLabel then
			self.text:SetFormattedText(displayString, '', set.name, not db.NoIcon and set.iconFileID or '')
		else
			self.text:SetFormattedText(displayString, db.Label ~= '' and db.Label or 'Set: ', set.name, not db.NoIcon and set.iconFileID or '')
		end
	end
end

local function ApplySettings(self, hex)
	if not db then
		db = E.global.datatexts.settings[self.name]
	end

	displayString = strjoin('', '%s', hex, '%s|r', not db.NoIcon and ' |T%s:16:16:0:0:64:64:4:60:4:60|t' or '')
end

DT:RegisterDatatext('Equipment Sets', nil, { 'EQUIPMENT_SETS_CHANGED', 'PLAYER_EQUIPMENT_CHANGED', 'EQUIPMENT_SWAP_FINISHED' }, OnEvent, nil, OnClick, OnEnter, nil, nil, nil, ApplySettings)
