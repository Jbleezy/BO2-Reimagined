require("T6.Lobby")
require("T6.Menus.PopupMenus")
require("T6.ListBox")

CoD.SelectMapListZombie = {}
CoD.SelectMapListZombie.GameModes = {}
CoD.SelectMapListZombie.GameModes[1] = {
	ui_zm_gamemodegroup = "zclassic",
	ui_gametype = "zclassic",
}
CoD.SelectMapListZombie.GameModes[2] = {
	ui_zm_gamemodegroup = "zsurvival",
	ui_gametype = "zstandard",
}
CoD.SelectMapListZombie.GameModes[3] = {
	ui_zm_gamemodegroup = "zencounter",
	ui_gametype = "zgrief",
}
CoD.SelectMapListZombie.GameModes[4] = {
	ui_zm_gamemodegroup = "zencounter",
	ui_gametype = "zrace",
}
CoD.SelectMapListZombie.GameModes[5] = {
	ui_zm_gamemodegroup = "zencounter",
	ui_gametype = "zcontainment",
}
CoD.SelectMapListZombie.GameModes[6] = {
	ui_zm_gamemodegroup = "zencounter",
	ui_gametype = "zmeat",
}
CoD.SelectMapListZombie.GameModes[7] = {
	ui_zm_gamemodegroup = "zencounter",
	ui_gametype = "zsr",
}
CoD.SelectMapListZombie.GameModes[8] = {
	ui_zm_gamemodegroup = "zencounter",
	ui_gametype = "zturned",
}
CoD.SelectMapListZombie.Maps = {}
CoD.SelectMapListZombie.Maps[1] = {
	ui_mapname = "zm_transit",
	ui_zm_mapstartlocation = "transit",
}
CoD.SelectMapListZombie.Maps[2] = {
	ui_mapname = "zm_highrise",
	ui_zm_mapstartlocation = "rooftop",
}
CoD.SelectMapListZombie.Maps[3] = {
	ui_mapname = "zm_buried",
	ui_zm_mapstartlocation = "processing",
}
CoD.SelectMapListZombie.Maps[4] = {
	ui_mapname = "zm_prison",
	ui_zm_mapstartlocation = "prison",
}
CoD.SelectMapListZombie.Maps[5] = {
	ui_mapname = "zm_tomb",
	ui_zm_mapstartlocation = "tomb",
}
CoD.SelectMapListZombie.Locations = {}
CoD.SelectMapListZombie.Locations[1] = {
	ui_mapname = "zm_nuked",
	ui_zm_mapstartlocation = "nuked",
}
CoD.SelectMapListZombie.Locations[2] = {
	ui_mapname = "zm_transit",
	ui_zm_mapstartlocation = "transit",
}
CoD.SelectMapListZombie.Locations[3] = {
	ui_mapname = "zm_transit",
	ui_zm_mapstartlocation = "diner",
}
CoD.SelectMapListZombie.Locations[4] = {
	ui_mapname = "zm_transit",
	ui_zm_mapstartlocation = "farm",
}
CoD.SelectMapListZombie.Locations[5] = {
	ui_mapname = "zm_transit",
	ui_zm_mapstartlocation = "power",
}
CoD.SelectMapListZombie.Locations[6] = {
	ui_mapname = "zm_transit",
	ui_zm_mapstartlocation = "town",
}
CoD.SelectMapListZombie.Locations[7] = {
	ui_mapname = "zm_transit",
	ui_zm_mapstartlocation = "tunnel",
}
CoD.SelectMapListZombie.Locations[8] = {
	ui_mapname = "zm_transit",
	ui_zm_mapstartlocation = "cornfield",
}
CoD.SelectMapListZombie.Locations[9] = {
	ui_mapname = "zm_highrise",
	ui_zm_mapstartlocation = "shopping_mall",
}
CoD.SelectMapListZombie.Locations[10] = {
	ui_mapname = "zm_highrise",
	ui_zm_mapstartlocation = "dragon_rooftop",
}
CoD.SelectMapListZombie.Locations[11] = {
	ui_mapname = "zm_highrise",
	ui_zm_mapstartlocation = "sweatshop",
}
CoD.SelectMapListZombie.Locations[12] = {
	ui_mapname = "zm_buried",
	ui_zm_mapstartlocation = "street",
}
CoD.SelectMapListZombie.Locations[13] = {
	ui_mapname = "zm_buried",
	ui_zm_mapstartlocation = "maze",
}
CoD.SelectMapListZombie.Locations[14] = {
	ui_mapname = "zm_prison",
	ui_zm_mapstartlocation = "cellblock",
}
CoD.SelectMapListZombie.Locations[15] = {
	ui_mapname = "zm_prison",
	ui_zm_mapstartlocation = "docks",
}
CoD.SelectMapListZombie.Locations[16] = {
	ui_mapname = "zm_tomb",
	ui_zm_mapstartlocation = "trenches",
}
CoD.SelectMapListZombie.Locations[17] = {
	ui_mapname = "zm_tomb",
	ui_zm_mapstartlocation = "excavation_site",
}
CoD.SelectMapListZombie.Locations[18] = {
	ui_mapname = "zm_tomb",
	ui_zm_mapstartlocation = "church",
}
CoD.SelectMapListZombie.Locations[19] = {
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

local function gameModeListSelectionClickedEventHandler(self, event)
	local index = self.listBox:getFocussedIndex()

	if index ~= nil then
		local prevTeamCount = Engine.GetGametypeSetting("teamCount")

		local gameTable = CoD.SelectMapListZombie.GameModes

		Engine.SetDvar("ui_zm_gamemodegroup", gameTable[index].ui_zm_gamemodegroup)
		Engine.SetGametype(gameTable[index].ui_gametype)

		local map, location = string.match(UIExpression.ProfileValueAsString(controller, CoD.profileKey_map), "(.*) (.*)")
		local mapTable = {}
		local mapIndex = 1

		if gameTable[index].ui_gametype == "zclassic" then
			mapTable = CoD.SelectMapListZombie.Maps
			mapIndex = CoD.SelectMapListZombie.GetKeyValueIndex(mapTable, "ui_mapname", map)
		else
			mapTable = CoD.SelectMapListZombie.Locations
			mapIndex = CoD.SelectMapListZombie.GetKeyValueIndex(mapTable, "ui_zm_mapstartlocation", location)
		end

		Engine.SetDvar("ui_mapname", mapTable[mapIndex].ui_mapname)
		Engine.SetDvar("ui_zm_mapstartlocation", mapTable[mapIndex].ui_zm_mapstartlocation)

		Engine.SetProfileVar(self.controller, CoD.profileKey_gametype, gameTable[index].ui_gametype)

		Engine.CommitProfileChanges(self.controller)

		local currTeamCount = Engine.GetGametypeSetting("teamCount")

		if currTeamCount ~= prevTeamCount then
			Engine.PartyHostReassignTeams()
		end
	end

	Engine.PartyHostClearUIState()

	self.occludedMenu:swapMenu("PrivateOnlineGameLobby", self.controller)
	self:goBack(self.controller)
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
	mutables.text:setText(Engine.Localize(UIExpression.TableLookup(nil, CoD.gametypesTable, 0, 0, 1, CoD.SelectMapListZombie.GameModes[index].ui_gametype, 2)))
end

function LUI.createMenu.SelectGameModeListZM(controller)
	local self = CoD.Menu.New("SelectGameModeListZM")
	self.controller = controller

	self:addLargePopupBackground()
	self:addSelectButton()
	self:addBackButton()

	self:addTitle(Engine.Localize("MPUI_CHANGE_GAME_MODE_CAPS"))

	local listBox = CoD.ListBox.new(nil, controller, 15, CoD.CoD9Button.Height, 250, gameModeListCreateButtonMutables, gameModeListGetButtonData, 5, 0)
	listBox:setLeftRight(true, false, 0, 250)
	listBox:setTopBottom(true, false, 75, 75 + 530)
	listBox:addScrollBar()

	local index = CoD.SelectMapListZombie.GetKeyValueIndex(CoD.SelectMapListZombie.GameModes, "ui_gametype", UIExpression.DvarString(nil, "ui_gametype"))

	if UIExpression.DvarBool(nil, "party_solo") == 1 then
		listBox:setTotalItems(2, index)
	else
		listBox:setTotalItems(#CoD.SelectMapListZombie.GameModes, index)
	end

	self:addElement(listBox)
	self.listBox = listBox

	self:registerEventHandler("click", gameModeListSelectionClickedEventHandler)

	return self
end

local function mapListSelectionClickedEventHandler(self, event)
	local index = self.listBox:getFocussedIndex()

	if index ~= nil then
		local mapTable = CoD.SelectMapListZombie.Maps

		if UIExpression.DvarString(nil, "ui_gametype") ~= "zclassic" then
			mapTable = CoD.SelectMapListZombie.Locations
		end

		Engine.SetDvar("ui_mapname", mapTable[index].ui_mapname)
		Engine.SetDvar("ui_zm_mapstartlocation", mapTable[index].ui_zm_mapstartlocation)

		local map, location = string.match(UIExpression.ProfileValueAsString(controller, CoD.profileKey_map), "(.*) (.*)")

		if UIExpression.DvarString(nil, "ui_gametype") == "zclassic" then
			Engine.SetProfileVar(self.controller, CoD.profileKey_map, mapTable[index].ui_mapname .. " " .. location)
		else
			Engine.SetProfileVar(self.controller, CoD.profileKey_map, map .. " " .. mapTable[index].ui_zm_mapstartlocation)
		end

		Engine.CommitProfileChanges(self.controller)
	end

	Engine.PartyHostClearUIState()

	self.occludedMenu:swapMenu("PrivateOnlineGameLobby", self.controller)
	self:goBack(self.controller)
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
	if UIExpression.DvarString(nil, "ui_gametype") == "zclassic" then
		mutables.text:setText(CoD.GetZombieGameTypeDescription(CoD.Zombie.GAMETYPE_ZCLASSIC, CoD.SelectMapListZombie.Maps[index].ui_mapname))
	else
		mutables.text:setText(Engine.Localize(UIExpression.TableLookup(nil, CoD.gametypesTable, 0, 5, 3, CoD.SelectMapListZombie.Locations[index].ui_zm_mapstartlocation, 4)))
	end
end

function LUI.createMenu.SelectMapListZM(controller)
	local self = CoD.Menu.New("SelectMapListZM")
	self.controller = controller

	self:addLargePopupBackground()
	self:addSelectButton()
	self:addBackButton()

	self:addTitle(Engine.Localize("MPUI_CHANGE_MAP_CAPS"))

	local listBox = CoD.ListBox.new(nil, controller, 15, CoD.CoD9Button.Height, 250, mapListCreateButtonMutables, mapListGetButtonData, 5, 0)
	listBox:setLeftRight(true, false, 0, 250)
	listBox:setTopBottom(true, false, 75, 75 + 530)
	listBox:addScrollBar()

	if UIExpression.DvarString(nil, "ui_gametype") == "zclassic" then
		local index = CoD.SelectMapListZombie.GetKeyValueIndex(CoD.SelectMapListZombie.Maps, "ui_mapname", UIExpression.DvarString(nil, "ui_mapname"))
		listBox:setTotalItems(#CoD.SelectMapListZombie.Maps, index)
	else
		local index = CoD.SelectMapListZombie.GetKeyValueIndex(CoD.SelectMapListZombie.Locations, "ui_zm_mapstartlocation", UIExpression.DvarString(nil, "ui_zm_mapstartlocation"))
		listBox:setTotalItems(#CoD.SelectMapListZombie.Locations, index)
	end

	self:addElement(listBox)
	self.listBox = listBox

	self:registerEventHandler("click", mapListSelectionClickedEventHandler)

	return self
end
