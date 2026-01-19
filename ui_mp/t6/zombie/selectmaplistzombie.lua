require("T6.Lobby")
require("T6.Menus.PopupMenus")
require("T6.ListBox")

CoD.SelectMapListZombie = {}
CoD.SelectMapListZombie.GameModes = {}
CoD.SelectMapListZombie.GameModes[1] = {
	localizedString = "ZMUI_ZCLASSIC_GAMEMODE_CAPS",
	ui_zm_gamemodegroup = "zclassic",
	ui_gametype = "zclassic",
}
CoD.SelectMapListZombie.GameModes[2] = {
	localizedString = "ZMUI_ZSTANDARD_CAPS",
	ui_zm_gamemodegroup = "zsurvival",
	ui_gametype = "zstandard",
}
CoD.SelectMapListZombie.GameModes[3] = {
	localizedString = "ZMUI_ZGRIEF_CAPS",
	ui_zm_gamemodegroup = "zencounter",
	ui_gametype = "zgrief",
}
CoD.SelectMapListZombie.GameModes[4] = {
	localizedString = "ZMUI_ZRACE_CAPS",
	ui_zm_gamemodegroup = "zencounter",
	ui_gametype = "zrace",
}
CoD.SelectMapListZombie.GameModes[5] = {
	localizedString = "ZMUI_ZCONTAINMENT_CAPS",
	ui_zm_gamemodegroup = "zencounter",
	ui_gametype = "zcontainment",
}
CoD.SelectMapListZombie.GameModes[6] = {
	localizedString = "ZMUI_ZMEAT_CAPS",
	ui_zm_gamemodegroup = "zencounter",
	ui_gametype = "zmeat",
}
CoD.SelectMapListZombie.GameModes[7] = {
	localizedString = "ZMUI_ZSR_CAPS",
	ui_zm_gamemodegroup = "zencounter",
	ui_gametype = "zsr",
}
CoD.SelectMapListZombie.Maps = {}
CoD.SelectMapListZombie.Maps[1] = {
	localizedString = "ZMUI_ZCLASSIC_ZM_TRANSIT_CAPS",
	ui_mapname = "zm_transit",
	ui_zm_mapstartlocation = "transit",
}
CoD.SelectMapListZombie.Maps[2] = {
	localizedString = "ZMUI_ZCLASSIC_ZM_HIGHRISE_CAPS",
	ui_mapname = "zm_highrise",
	ui_zm_mapstartlocation = "rooftop",
}
CoD.SelectMapListZombie.Maps[3] = {
	localizedString = "ZMUI_ZCLASSIC_ZM_BURIED_CAPS",
	ui_mapname = "zm_buried",
	ui_zm_mapstartlocation = "processing",
}
CoD.SelectMapListZombie.Maps[4] = {
	localizedString = "ZMUI_ZCLASSIC_ZM_PRISON_CAPS",
	ui_mapname = "zm_prison",
	ui_zm_mapstartlocation = "prison",
}
CoD.SelectMapListZombie.Maps[5] = {
	localizedString = "ZMUI_ZCLASSIC_ZM_TOMB_CAPS",
	ui_mapname = "zm_tomb",
	ui_zm_mapstartlocation = "tomb",
}
CoD.SelectMapListZombie.Locations = {}
CoD.SelectMapListZombie.Locations[1] = {
	localizedString = "ZMUI_NUKED_STARTLOC_CAPS",
	ui_mapname = "zm_nuked",
	ui_zm_mapstartlocation = "nuked",
}
CoD.SelectMapListZombie.Locations[2] = {
	localizedString = "ZMUI_TRANSIT_STARTLOC_CAPS",
	ui_mapname = "zm_transit",
	ui_zm_mapstartlocation = "transit",
}
CoD.SelectMapListZombie.Locations[3] = {
	localizedString = "ZMUI_DINER_CAPS",
	ui_mapname = "zm_transit",
	ui_zm_mapstartlocation = "diner",
}
CoD.SelectMapListZombie.Locations[4] = {
	localizedString = "ZMUI_FARM_CAPS",
	ui_mapname = "zm_transit",
	ui_zm_mapstartlocation = "farm",
}
CoD.SelectMapListZombie.Locations[5] = {
	localizedString = "ZMUI_POWER_CAPS",
	ui_mapname = "zm_transit",
	ui_zm_mapstartlocation = "power",
}
CoD.SelectMapListZombie.Locations[6] = {
	localizedString = "ZMUI_TOWN_CAPS",
	ui_mapname = "zm_transit",
	ui_zm_mapstartlocation = "town",
}
CoD.SelectMapListZombie.Locations[7] = {
	localizedString = "ZMUI_TUNNEL_CAPS",
	ui_mapname = "zm_transit",
	ui_zm_mapstartlocation = "tunnel",
}
CoD.SelectMapListZombie.Locations[8] = {
	localizedString = "ZMUI_CORNFIELD_CAPS",
	ui_mapname = "zm_transit",
	ui_zm_mapstartlocation = "cornfield",
}
CoD.SelectMapListZombie.Locations[9] = {
	localizedString = "ZMUI_SHOPPING_MALL_CAPS",
	ui_mapname = "zm_highrise",
	ui_zm_mapstartlocation = "shopping_mall",
}
CoD.SelectMapListZombie.Locations[10] = {
	localizedString = "ZMUI_DRAGON_ROOFTOP_CAPS",
	ui_mapname = "zm_highrise",
	ui_zm_mapstartlocation = "dragon_rooftop",
}
CoD.SelectMapListZombie.Locations[11] = {
	localizedString = "ZMUI_SWEATSHOP_CAPS",
	ui_mapname = "zm_highrise",
	ui_zm_mapstartlocation = "sweatshop",
}
CoD.SelectMapListZombie.Locations[12] = {
	localizedString = "ZMUI_STREET_LOC_CAPS",
	ui_mapname = "zm_buried",
	ui_zm_mapstartlocation = "street",
}
CoD.SelectMapListZombie.Locations[13] = {
	localizedString = "ZMUI_MAZE_CAPS",
	ui_mapname = "zm_buried",
	ui_zm_mapstartlocation = "maze",
}
CoD.SelectMapListZombie.Locations[14] = {
	localizedString = "ZMUI_CELLBLOCK_CAPS",
	ui_mapname = "zm_prison",
	ui_zm_mapstartlocation = "cellblock",
}
CoD.SelectMapListZombie.Locations[15] = {
	localizedString = "ZMUI_DOCKS_CAPS",
	ui_mapname = "zm_prison",
	ui_zm_mapstartlocation = "docks",
}
CoD.SelectMapListZombie.Locations[16] = {
	localizedString = "ZMUI_TRENCHES_CAPS",
	ui_mapname = "zm_tomb",
	ui_zm_mapstartlocation = "trenches",
}
CoD.SelectMapListZombie.Locations[17] = {
	localizedString = "ZMUI_EXCAVATION_SITE_CAPS",
	ui_mapname = "zm_tomb",
	ui_zm_mapstartlocation = "excavation_site",
}
CoD.SelectMapListZombie.Locations[18] = {
	localizedString = "ZMUI_CHURCH_CAPS",
	ui_mapname = "zm_tomb",
	ui_zm_mapstartlocation = "church",
}
CoD.SelectMapListZombie.Locations[19] = {
	localizedString = "ZMUI_CRAZY_PLACE_CAPS",
	ui_mapname = "zm_tomb",
	ui_zm_mapstartlocation = "crazy_place",
}

CoD.SelectMapListZombie.GetKeyValueIndex = function(table, key, value)
	for i, v in ipairs(table) do
		if v[key] == value then
			return i
		end
	end

	return 1
end

local function setGameModeDvars(controller, commit)
	local index = CoD.SelectMapListZombie.GameModeIndex

	if index ~= nil then
		Engine.SetDvar("ui_zm_gamemodegroup", CoD.SelectMapListZombie.GameModes[index].ui_zm_gamemodegroup)
		Engine.SetGametype(CoD.SelectMapListZombie.GameModes[index].ui_gametype)

		Engine.SetProfileVar(controller, CoD.profileKey_gametype, CoD.SelectMapListZombie.GameModes[index].ui_gametype)
	end

	if commit then
		Engine.CommitProfileChanges(controller)
	end
end

local function setMapDvars(controller, commit)
	local index = CoD.SelectMapListZombie.MapIndex

	if index ~= nil then
		Engine.SetDvar("ui_mapname", CoD.SelectMapListZombie.Maps[index].ui_mapname)
		Engine.SetDvar("ui_zm_mapstartlocation", CoD.SelectMapListZombie.Maps[index].ui_zm_mapstartlocation)

		Engine.SetProfileVar(controller, CoD.profileKey_map, CoD.SelectMapListZombie.Maps[index].ui_mapname)
	end

	if commit then
		Engine.CommitProfileChanges(controller)
	end
end

local function setLocationDvars(controller, commit)
	local index = CoD.SelectMapListZombie.LocationIndex

	if index ~= nil then
		Engine.SetDvar("ui_mapname", CoD.SelectMapListZombie.Locations[index].ui_mapname)
		Engine.SetDvar("ui_zm_mapstartlocation", CoD.SelectMapListZombie.Locations[index].ui_zm_mapstartlocation)

		Engine.SetProfileVar(controller, CoD.profileKey_map, CoD.SelectMapListZombie.Locations[index].ui_zm_mapstartlocation)
	end

	if commit then
		Engine.CommitProfileChanges(controller)
	end
end

local function gameModeListFocusChangedEventHandler(self, event)
	CoD.SelectMapListZombie.GameModeIndex = self.listBox:getFocussedIndex()
end

local function gameModeListSelectionClickedEventHandler(self, event)
	CoD.SelectMapListZombie.GameModeIndex = self.listBox:getFocussedIndex()

	if CoD.SelectMapListZombie.GameModes[CoD.SelectMapListZombie.GameModeIndex].ui_gametype == "zclassic" then
		self:openMenu("SelectMapListZM", self.controller)
	else
		self:openMenu("SelectLocationListZM", self.controller)
	end

	self:close()
end

local function gameModeListCreateButtonMutables(controller, mutables)
	local text = LUI.UIText.new()
	text:setLeftRight(true, false, 2, 2)
	text:setTopBottom(true, true, 0, 0)
	text:setRGB(1, 1, 1)
	text:setAlpha(1)
	mutables:addElement(text)
	mutables.text = text
end

local function gameModeListGetButtonData(controller, index, mutables, self)
	mutables.text:setText(Engine.Localize(CoD.SelectMapListZombie.GameModes[index].localizedString))
end

function LUI.createMenu.SelectGameModeListZM(controller)
	local self = CoD.Menu.New("SelectGameModeListZM")
	self.controller = controller

	self:setPreviousMenu("PrivateOnlineGameLobby")

	self:registerEventHandler("open_menu", CoD.Lobby.OpenMenu)
	self:addSelectButton()
	self:addBackButton()

	self:addTitle(Engine.Localize("MPUI_GAMEMODE_CAPS"))

	CoD.SelectMapListZombie.GameModeIndex = CoD.SelectMapListZombie.GetKeyValueIndex(CoD.SelectMapListZombie.GameModes, "ui_gametype", UIExpression.DvarString(nil, "ui_gametype"))

	local listBox = CoD.ListBox.new(nil, controller, 15, CoD.CoD9Button.Height, 250, gameModeListCreateButtonMutables, gameModeListGetButtonData, 5, 0)
	listBox:setLeftRight(true, false, 0, 250)
	listBox:setTopBottom(true, false, 75, 75 + 530)
	listBox:addScrollBar()

	if UIExpression.DvarBool(nil, "party_solo") == 1 then
		if CoD.SelectMapListZombie.GameModeIndex > 2 then
			CoD.SelectMapListZombie.GameModeIndex = 2
			setGameModeDvars(controller, true)
		end

		listBox:setTotalItems(2, CoD.SelectMapListZombie.GameModeIndex)
	else
		listBox:setTotalItems(#CoD.SelectMapListZombie.GameModes, CoD.SelectMapListZombie.GameModeIndex)
	end

	self:addElement(listBox)
	self.listBox = listBox

	self:registerEventHandler("listbox_focus_changed", gameModeListFocusChangedEventHandler)
	self:registerEventHandler("click", gameModeListSelectionClickedEventHandler)

	Engine.PartyHostSetUIState(CoD.PARTYHOST_STATE_SELECTING_GAMETYPE)
	CoD.PrivateGameLobby.FadeIn = true

	return self
end

local function mapListFocusChangedEventHandler(self, event)
	CoD.SelectMapListZombie.MapIndex = self.listBox:getFocussedIndex()
end

local function mapListSelectionClickedEventHandler(self, event)
	CoD.SelectMapListZombie.MapIndex = self.listBox:getFocussedIndex()

	local prevTeamCount = Engine.GetGametypeSetting("teamCount")

	setGameModeDvars(self.controller, false)
	setMapDvars(self.controller, true)

	self:openMenu("PrivateOnlineGameLobby", self.controller)

	local currTeamCount = Engine.GetGametypeSetting("teamCount")

	if currTeamCount ~= prevTeamCount then
		Engine.PartyHostReassignTeams()
	end

	self:close()
end

local function mapListCreateButtonMutables(controller, mutables)
	local text = LUI.UIText.new()
	text:setLeftRight(true, false, 2, 2)
	text:setTopBottom(true, true, 0, 0)
	text:setRGB(1, 1, 1)
	text:setAlpha(1)
	mutables:addElement(text)
	mutables.text = text
end

local function mapListGetButtonData(controller, index, mutables, self)
	mutables.text:setText(Engine.Localize(CoD.SelectMapListZombie.Maps[index].localizedString))
end

function LUI.createMenu.SelectMapListZM(controller)
	local self = CoD.Menu.New("SelectMapListZM")
	self.controller = controller

	self:setPreviousMenu("SelectGameModeListZM")
	self:registerEventHandler("open_menu", CoD.Lobby.OpenMenu)
	self:addSelectButton()
	self:addBackButton()

	self:addTitle(Engine.Localize("MPUI_MAPS_CAPS"))

	CoD.SelectMapListZombie.MapIndex = 1

	if UIExpression.DvarString(nil, "ui_gametype") == "zclassic" then
		CoD.SelectMapListZombie.MapIndex = CoD.SelectMapListZombie.GetKeyValueIndex(CoD.SelectMapListZombie.Maps, "ui_mapname", UIExpression.DvarString(nil, "ui_mapname"))
	end

	local listBox = CoD.ListBox.new(nil, controller, 15, CoD.CoD9Button.Height, 250, mapListCreateButtonMutables, mapListGetButtonData, 5, 0)
	listBox:setLeftRight(true, false, 0, 250)
	listBox:setTopBottom(true, false, 75, 75 + 530)
	listBox:addScrollBar()
	listBox:setTotalItems(#CoD.SelectMapListZombie.Maps, CoD.SelectMapListZombie.MapIndex)
	self:addElement(listBox)
	self.listBox = listBox

	self:registerEventHandler("listbox_focus_changed", mapListFocusChangedEventHandler)
	self:registerEventHandler("click", mapListSelectionClickedEventHandler)

	Engine.PartyHostSetUIState(CoD.PARTYHOST_STATE_SELECTING_MAP)
	CoD.PrivateGameLobby.FadeIn = true

	return self
end

local function locationListFocusChangedEventHandler(self, event)
	CoD.SelectMapListZombie.LocationIndex = self.listBox:getFocussedIndex()
end

local function locationListSelectionClickedEventHandler(self, event)
	CoD.SelectMapListZombie.LocationIndex = self.listBox:getFocussedIndex()

	local prevTeamCount = Engine.GetGametypeSetting("teamCount")

	setGameModeDvars(self.controller, false)
	setLocationDvars(self.controller, true)

	self:openMenu("PrivateOnlineGameLobby", self.controller)

	local currTeamCount = Engine.GetGametypeSetting("teamCount")

	if currTeamCount ~= prevTeamCount then
		Engine.PartyHostReassignTeams()
	end

	self:close()
end

local function locationListCreateButtonMutables(controller, mutables)
	local text = LUI.UIText.new()
	text:setLeftRight(true, false, 2, 2)
	text:setTopBottom(true, true, 0, 0)
	text:setRGB(1, 1, 1)
	text:setAlpha(1)
	mutables:addElement(text)
	mutables.text = text
end

local function locationListGetButtonData(controller, index, mutables, self)
	mutables.text:setText(Engine.Localize(CoD.SelectMapListZombie.Locations[index].localizedString))
end

function LUI.createMenu.SelectLocationListZM(controller)
	local self = CoD.Menu.New("SelectLocationListZM")
	self.controller = controller

	self:setPreviousMenu("SelectGameModeListZM")
	self:registerEventHandler("open_menu", CoD.Lobby.OpenMenu)
	self:addSelectButton()
	self:addBackButton()

	self:addTitle(Engine.Localize("MPUI_MAPS_CAPS"))

	CoD.SelectMapListZombie.LocationIndex = 1

	if UIExpression.DvarString(nil, "ui_gametype") ~= "zclassic" then
		CoD.SelectMapListZombie.LocationIndex = CoD.SelectMapListZombie.GetKeyValueIndex(CoD.SelectMapListZombie.Locations, "ui_zm_mapstartlocation", UIExpression.DvarString(nil, "ui_zm_mapstartlocation"))
	end

	local listBox = CoD.ListBox.new(nil, controller, 15, CoD.CoD9Button.Height, 250, locationListCreateButtonMutables, locationListGetButtonData, 5, 0)
	listBox:setLeftRight(true, false, 0, 250)
	listBox:setTopBottom(true, false, 75, 75 + 530)
	listBox:addScrollBar()
	listBox:setTotalItems(#CoD.SelectMapListZombie.Locations, CoD.SelectMapListZombie.LocationIndex)
	self:addElement(listBox)
	self.listBox = listBox

	self:registerEventHandler("listbox_focus_changed", locationListFocusChangedEventHandler)
	self:registerEventHandler("click", locationListSelectionClickedEventHandler)

	Engine.PartyHostSetUIState(CoD.PARTYHOST_STATE_SELECTING_MAP)
	CoD.PrivateGameLobby.FadeIn = true

	return self
end
