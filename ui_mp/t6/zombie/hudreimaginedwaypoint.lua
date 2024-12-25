CoD.ReimaginedWaypoint = {}
CoD.PlayerWaypoint = InheritFrom(CoD.ObjectiveWaypoint)
CoD.PlayerWaypoint.FLAG_ALIVE = 0
CoD.PlayerWaypoint.FLAG_DOWN = 1
CoD.PlayerWaypoint.FLAG_DEAD = 2
CoD.PlayerWaypoint.FLAG_TARGET = 3
CoD.PlayerTargetWaypoint = InheritFrom(CoD.ObjectiveWaypoint)
CoD.PlayerDownWaypoint = InheritFrom(CoD.ObjectiveWaypoint)
CoD.PlayerAliveWaypoint = InheritFrom(CoD.ObjectiveWaypoint)
CoD.PlayerHeadIcon = InheritFrom(CoD.ObjectiveWaypoint)

LUI.createMenu.PlayerTargetWaypointArea = function(LocalClientIndex)
	local safeArea = CoD.GametypeBase.new("PlayerTargetWaypointArea", LocalClientIndex)

	safeArea.objectiveTypes.OBJ_PLAYER_1 = CoD.PlayerTargetWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_2 = CoD.PlayerTargetWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_3 = CoD.PlayerTargetWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_4 = CoD.PlayerTargetWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_5 = CoD.PlayerTargetWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_6 = CoD.PlayerTargetWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_7 = CoD.PlayerTargetWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_8 = CoD.PlayerTargetWaypoint

	safeArea:registerEventHandler("hud_update_refresh", CoD.GametypeBase.Refresh)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_IN_AFTERLIFE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.PlayerWaypoint.UpdateVisibility)

	return safeArea
end

LUI.createMenu.PlayerDownWaypointArea = function(LocalClientIndex)
	local safeArea = CoD.GametypeBase.new("PlayerDownWaypointArea", LocalClientIndex)

	safeArea.objectiveTypes.OBJ_PLAYER_1 = CoD.PlayerDownWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_2 = CoD.PlayerDownWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_3 = CoD.PlayerDownWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_4 = CoD.PlayerDownWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_5 = CoD.PlayerDownWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_6 = CoD.PlayerDownWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_7 = CoD.PlayerDownWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_8 = CoD.PlayerDownWaypoint

	safeArea:registerEventHandler("hud_update_refresh", CoD.GametypeBase.Refresh)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_IN_AFTERLIFE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.PlayerWaypoint.UpdateVisibility)

	return safeArea
end

LUI.createMenu.PlayerAliveWaypointArea = function(LocalClientIndex)
	local safeArea = CoD.GametypeBase.new("PlayerAliveWaypointArea", LocalClientIndex)

	safeArea.objectiveTypes.OBJ_PLAYER_1 = CoD.PlayerAliveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_2 = CoD.PlayerAliveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_3 = CoD.PlayerAliveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_4 = CoD.PlayerAliveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_5 = CoD.PlayerAliveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_6 = CoD.PlayerAliveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_7 = CoD.PlayerAliveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_8 = CoD.PlayerAliveWaypoint

	safeArea:registerEventHandler("hud_update_refresh", CoD.GametypeBase.Refresh)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_IN_AFTERLIFE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.PlayerWaypoint.UpdateVisibility)

	return safeArea
end

CoD.PlayerWaypoint.UpdateVisibility = function(Menu, ClientInstance)
	local controller = ClientInstance.controller
	if UIExpression.IsVisibilityBitSet(controller, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_PLAYER_IN_AFTERLIFE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_AMMO_COUNTER_HIDE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_UI_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_SCOREBOARD_OPEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_SCOPED) == 0 and (not CoD.IsShoutcaster(controller) or CoD.ExeProfileVarBool(controller, "shoutcaster_scorestreaks") and Engine.IsSpectatingActiveClient(controller)) and CoD.FSM_VISIBILITY(controller) == 0 then
		if Menu.visible ~= true then
			Menu:setAlpha(1)
			Menu.m_inputDisabled = nil
			Menu.visible = true
		end
	elseif Menu.visible == true then
		Menu:setAlpha(0)
		Menu.m_inputDisabled = true
		Menu.visible = nil
	end
	Menu:dispatchEventToChildren(ClientInstance)
end

CoD.PlayerTargetWaypoint.new = function(Menu, ObjectiveIndex)
	local waypoint = CoD.ObjectiveWaypoint.new(Menu, ObjectiveIndex, 0)
	waypoint:setClass(CoD.PlayerTargetWaypoint)
	waypoint:setLeftRight(false, false, -waypoint.iconWidth / 2, waypoint.iconWidth / 2)
	waypoint:setTopBottom(false, true, -waypoint.iconHeight, 0)
	waypoint.alphaController:setAlpha(0)
	waypoint.mainImage:setLeftRight(false, false, -24, 24)
	waypoint.mainImage:setTopBottom(false, false, -39, 9)
	waypoint.arrowImage:setLeftRight(false, false, -12, 12)
	waypoint.arrowImage:setTopBottom(false, false, 21, 45)
	waypoint.edgePointerContainer:setTopBottom(true, true, -15, -15)
	waypoint.updateProgress = CoD.NullFunction
	waypoint.updatePlayerUsing = CoD.NullFunction

	local objectiveName = Engine.GetObjectiveName(Menu, ObjectiveIndex)
	waypoint:registerEventHandler("objective_update_" .. objectiveName, waypoint.update)
	waypoint:registerEventHandler("hud_update_team_change", waypoint.update)
	waypoint:registerEventHandler("hud_update_other_player_team_change", waypoint.update)

	return waypoint
end

CoD.PlayerTargetWaypoint.update = function(Menu, ClientInstance)
	local index = Menu.index
	local controller = ClientInstance.controller
	local clientNum = Engine.GetPredictedClientNum(controller)
	local objectiveFlags = Engine.GetObjectiveGamemodeFlags(Menu, index)
	local objectiveEntity = Engine.GetObjectiveEntity(Menu, index)
	local clientTeam = Engine.GetTeamID(controller, clientNum)
	local objectiveEntityTeam = Engine.GetTeamID(controller, objectiveEntity)
	local gamemodeGroup = UIExpression.DvarString(nil, "ui_zm_gamemodegroup")

	if objectiveFlags == CoD.PlayerWaypoint.FLAG_TARGET and clientTeam ~= objectiveEntityTeam and gamemodeGroup ~= CoD.Zombie.GAMETYPEGROUP_ZENCOUNTER then
		local x, y, z = Engine.GetObjectivePosition(Menu, index)
		local targetIcon = ""

		if clientTeam == objectiveEntityTeam then
			targetIcon = "white_waypoint_escort"
			Menu.mainImage:setRGB(0, 1, 0)
			Menu.arrowImage:setRGB(0, 1, 0)
		else
			targetIcon = "white_waypoint_kill"
			Menu.mainImage:setRGB(1, 0, 0)
			Menu.arrowImage:setRGB(1, 0, 0)
		end

		Menu.alphaController:setAlpha(1)
		Menu.mainImage:setAlpha(1)
		Menu.arrowImage:setAlpha(1)
		Menu.mainImage:setImage(RegisterMaterial(targetIcon))
		Menu.arrowImage:setImage(RegisterMaterial("waypoint_revive_arrow"))
		Menu.zOffset = z
	else
		Menu.alphaController:setAlpha(0)
	end

	CoD.PlayerTargetWaypoint.super.update(Menu, ClientInstance)
end

CoD.PlayerDownWaypoint.new = function(Menu, ObjectiveIndex)
	local waypoint = CoD.ObjectiveWaypoint.new(Menu, ObjectiveIndex, 0)
	waypoint:setClass(CoD.PlayerDownWaypoint)
	waypoint.alphaController:setAlpha(0)
	waypoint.mainImage:setLeftRight(false, false, -24, 24)
	waypoint.mainImage:setTopBottom(false, false, -39, 9)
	waypoint.arrowImage:setLeftRight(false, false, -12, 12)
	waypoint.arrowImage:setTopBottom(false, false, 21, 45)
	waypoint.edgePointerContainer:setTopBottom(true, true, -15, -15)
	waypoint.updateProgress = CoD.PlayerDownWaypoint.updateProgress
	waypoint.updatePlayerUsing = CoD.PlayerDownWaypoint.updatePlayerUsing
	waypoint.snapToHeight = 80

	local objectiveName = Engine.GetObjectiveName(Menu, ObjectiveIndex)
	waypoint:registerEventHandler("objective_update_" .. objectiveName, waypoint.update)
	waypoint:registerEventHandler("hud_update_team_change", waypoint.update)
	waypoint:registerEventHandler("hud_update_other_player_team_change", waypoint.update)

	return waypoint
end

CoD.PlayerDownWaypoint.update = function(Menu, ClientInstance)
	local index = Menu.index
	local controller = ClientInstance.controller
	local clientNum = Engine.GetPredictedClientNum(controller)
	local objectiveFlags = Engine.GetObjectiveGamemodeFlags(Menu, index)
	local objectiveEntity = Engine.GetObjectiveEntity(Menu, index)
	local clientTeam = Engine.GetTeamID(controller, clientNum)
	local objectiveEntityTeam = Engine.GetTeamID(controller, objectiveEntity)
	local gamemodeGroup = UIExpression.DvarString(nil, "ui_zm_gamemodegroup")

	if objectiveFlags == CoD.PlayerWaypoint.FLAG_DOWN and (clientTeam == objectiveEntityTeam or gamemodeGroup == CoD.Zombie.GAMETYPEGROUP_ZENCOUNTER) then
		local objectiveIsPlayerUsing = Engine.ObjectiveIsPlayerUsing(controller, Menu.index, clientNum)
		local reviveIcon = "waypoint_revive"

		if gamemodeGroup == CoD.Zombie.GAMETYPEGROUP_ZENCOUNTER then
			local faction = Engine.GetFactionForTeam(objectiveEntityTeam)

			if faction == "cdc" or faction == "cia" then
				reviveIcon = "waypoint_revive_" .. faction .. "_zm"
			else
				reviveIcon = "waypoint_revive_" .. faction
			end
		end

		Menu.alphaController:setAlpha(1)
		Menu.mainImage:setAlpha(1)
		Menu.arrowImage:setAlpha(1)
		Menu.mainImage:setImage(RegisterMaterial(reviveIcon))
		Menu.arrowImage:setImage(RegisterMaterial("waypoint_revive_arrow"))
		Menu.zOffset = 30
	else
		Menu.alphaController:setAlpha(0)
	end

	CoD.PlayerDownWaypoint.super.update(Menu, ClientInstance)
end

CoD.PlayerDownWaypoint.updateProgress = function(Menu, LocalClientIndex, IsAnyPlayerUsing, Arg4)
	CoD.PlayerDownWaypoint.updateProgressAndPlayerUsing(Menu, LocalClientIndex, IsAnyPlayerUsing, Arg4)
end

CoD.PlayerDownWaypoint.updatePlayerUsing = function(Menu, LocalClientIndex, IsAnyPlayerUsing, Arg4)
	CoD.PlayerDownWaypoint.updateProgressAndPlayerUsing(Menu, LocalClientIndex, IsAnyPlayerUsing, Arg4)
end

CoD.PlayerDownWaypoint.updateProgressAndPlayerUsing = function(Menu, LocalClientIndex, IsAnyPlayerUsing, Arg4)
	local clientNum = Engine.GetPredictedClientNum(LocalClientIndex)
	local objectiveIsPlayerUsing = Engine.ObjectiveIsPlayerUsing(LocalClientIndex, Menu.index, clientNum)

	if IsAnyPlayerUsing then
		Menu.mainImage:setRGB(1, 1, 1)
		Menu.arrowImage:setRGB(1, 1, 1)

		if Menu.playerUsing == objectiveIsPlayerUsing then
			return
		end

		if Menu.playerUsing ~= nil then
			Menu:beginAnimation("snap_in", Menu.snapToTime, true, true)
		end

		Menu:setEntityContainerStopUpdating(true)
		Menu:setLeftRight(false, false, -Menu.largeIconWidth / 2, Menu.largeIconWidth / 2)
		Menu:setTopBottom(false, false, -Menu.largeIconHeight - Menu.snapToHeight, -Menu.snapToHeight)
		Menu.edgePointerContainer:setAlpha(0)
	else
		local objectiveProgress = Engine.GetObjectiveProgress(LocalClientIndex, Menu.index)

		Menu.mainImage:setRGB(1, 1 - objectiveProgress, 0)
		Menu.arrowImage:setRGB(1, 1 - objectiveProgress, 0)

		if Menu.playerUsing == objectiveIsPlayerUsing then
			return
		end

		if Menu.playerUsing ~= nil then
			Menu:beginAnimation("snap_out", Menu.snapToTime, true, true)
		end

		Menu:setEntityContainerStopUpdating(false)
		Menu:setLeftRight(false, false, -Menu.iconWidth / 2, Menu.iconWidth / 2)
		Menu:setTopBottom(false, true, -Menu.iconHeight, 0)
		Menu.edgePointerContainer:setAlpha(1)
	end

	Menu.playerUsing = objectiveIsPlayerUsing
end

CoD.PlayerAliveWaypoint.new = function(Menu, ObjectiveIndex)
	local waypoint = CoD.ObjectiveWaypoint.new(Menu, ObjectiveIndex, 0)
	waypoint:setClass(CoD.PlayerAliveWaypoint)
	waypoint:setLeftRight(false, false, -waypoint.iconWidth / 2, waypoint.iconWidth / 2)
	waypoint:setTopBottom(false, true, -waypoint.iconHeight, 0)
	waypoint.alphaController:setAlpha(0)
	waypoint.mainImage:setAlpha(0)
	waypoint.mainImage:setLeftRight(false, false, -24, 24)
	waypoint.mainImage:setTopBottom(false, false, -39, 9)
	waypoint.arrowImage:setLeftRight(false, false, -18, 18)
	waypoint.arrowImage:setTopBottom(false, false, 24, 42)
	waypoint.edgePointerContainer:setTopBottom(true, true, -15, -15)
	waypoint.updateProgress = CoD.NullFunction
	waypoint.updatePlayerUsing = CoD.NullFunction

	local objectiveName = Engine.GetObjectiveName(Menu, ObjectiveIndex)
	waypoint:registerEventHandler("objective_update_" .. objectiveName, waypoint.update)
	waypoint:registerEventHandler("hud_update_team_change", waypoint.update)
	waypoint:registerEventHandler("hud_update_other_player_team_change", waypoint.update)
	waypoint:registerEventHandler("entity_container_clamped", waypoint.Clamped)
	waypoint:registerEventHandler("entity_container_unclamped", waypoint.Unclamped)

	return waypoint
end

CoD.PlayerAliveWaypoint.update = function(Menu, ClientInstance)
	local index = Menu.index
	local controller = ClientInstance.controller
	local clientNum = Engine.GetPredictedClientNum(controller)
	local objectiveFlags = Engine.GetObjectiveGamemodeFlags(Menu, index)
	local objectiveEntity = Engine.GetObjectiveEntity(Menu, index)
	local clientTeam = Engine.GetTeamID(controller, clientNum)
	local objectiveEntityTeam = Engine.GetTeamID(controller, objectiveEntity)
	local gamemodeGroup = UIExpression.DvarString(nil, "ui_zm_gamemodegroup")

	if objectiveFlags == CoD.PlayerWaypoint.FLAG_ALIVE and clientTeam == objectiveEntityTeam and Menu.clamped then
		Menu.alphaController:setAlpha(1)
		Menu.mainImage:setAlpha(0)
		Menu.arrowImage:setLeftRight(false, false, -18, 18)
		Menu.arrowImage:setTopBottom(false, false, 24, 42)
		Menu.arrowImage:setImage(RegisterMaterial("hud_offscreenobjectivepointer"))
		Menu:setPriority(0)
		Menu.zOffset = 30
		Menu.enemyTarget = nil
	elseif objectiveFlags == CoD.PlayerWaypoint.FLAG_ALIVE and clientTeam ~= objectiveEntityTeam and gamemodeGroup ~= CoD.Zombie.GAMETYPEGROUP_ZENCOUNTER then
		local x, y, z = Engine.GetObjectivePosition(Menu, index)
		local killIcon = "waypoint_kill_red"

		Menu.alphaController:setAlpha(1)
		Menu.mainImage:setAlpha(1)
		Menu.arrowImage:setAlpha(1)
		Menu.arrowImage:setLeftRight(false, false, -12, 12)
		Menu.arrowImage:setTopBottom(false, false, 21, 45)
		Menu.mainImage:setRGB(1, 0, 0)
		Menu.arrowImage:setRGB(1, 0, 0)
		Menu.mainImage:setImage(RegisterMaterial(killIcon))
		Menu.arrowImage:setImage(RegisterMaterial("waypoint_revive_arrow"))
		Menu:setPriority(100)
		Menu.zOffset = z
		Menu.enemyTarget = true
	else
		Menu.alphaController:setAlpha(0)
	end

	CoD.PlayerAliveWaypoint.super.update(Menu, ClientInstance)
end

CoD.PlayerAliveWaypoint.Clamped = function(Menu, ClientInstance)
	if Menu.edgePointerContainer.setupEdgePointer then
		Menu.clamped = true

		local index = Menu.index
		local controller = ClientInstance.controller
		local clientNum = Engine.GetPredictedClientNum(controller)
		local objectiveFlags = Engine.GetObjectiveGamemodeFlags(Menu, index)
		local objectiveEntity = Engine.GetObjectiveEntity(Menu, index)
		local clientTeam = Engine.GetTeamID(controller, clientNum)
		local objectiveEntityTeam = Engine.GetTeamID(controller, objectiveEntity)

		if objectiveFlags == CoD.PlayerWaypoint.FLAG_ALIVE and clientTeam == objectiveEntityTeam then
			Menu.alphaController:setAlpha(1)
		end

		Menu.edgePointerContainer:setupEdgePointer(90)
	end
end

CoD.PlayerAliveWaypoint.Unclamped = function(Menu, ClientInstance)
	Menu.clamped = nil

	if not Menu.enemyTarget then
		Menu.alphaController:setAlpha(0)
	end

	Menu.edgePointerContainer:setupUIElement()
	Menu.edgePointerContainer:setZRot(0)
end

LUI.createMenu.PlayerHeadIconArea = function(LocalClientIndex)
	local safeArea = CoD.GametypeBase.new("PlayerHeadIconArea", LocalClientIndex)

	safeArea.objectiveTypes.OBJ_PLAYER_1 = CoD.PlayerHeadIcon
	safeArea.objectiveTypes.OBJ_PLAYER_2 = CoD.PlayerHeadIcon
	safeArea.objectiveTypes.OBJ_PLAYER_3 = CoD.PlayerHeadIcon
	safeArea.objectiveTypes.OBJ_PLAYER_4 = CoD.PlayerHeadIcon
	safeArea.objectiveTypes.OBJ_PLAYER_5 = CoD.PlayerHeadIcon
	safeArea.objectiveTypes.OBJ_PLAYER_6 = CoD.PlayerHeadIcon
	safeArea.objectiveTypes.OBJ_PLAYER_7 = CoD.PlayerHeadIcon
	safeArea.objectiveTypes.OBJ_PLAYER_8 = CoD.PlayerHeadIcon

	safeArea:registerEventHandler("hud_update_refresh", CoD.GametypeBase.Refresh)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.PlayerHeadIcon.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_IN_AFTERLIFE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.PlayerHeadIcon.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.PlayerHeadIcon.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.PlayerHeadIcon.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.PlayerHeadIcon.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.PlayerHeadIcon.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.PlayerHeadIcon.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.PlayerHeadIcon.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.PlayerHeadIcon.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.PlayerHeadIcon.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.PlayerHeadIcon.UpdateVisibility)

	return safeArea
end

CoD.PlayerHeadIcon.UpdateVisibility = function(Menu, ClientInstance)
	local controller = ClientInstance.controller
	if UIExpression.DvarBool(nil, "ui_hud_head_icons") == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_PLAYER_IN_AFTERLIFE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_AMMO_COUNTER_HIDE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_UI_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_SCOREBOARD_OPEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_SCOPED) == 0 and (not CoD.IsShoutcaster(controller) or CoD.ExeProfileVarBool(controller, "shoutcaster_scorestreaks") and Engine.IsSpectatingActiveClient(controller)) and CoD.FSM_VISIBILITY(controller) == 0 then
		if Menu.visible ~= true then
			Menu:setAlpha(1)
			Menu.m_inputDisabled = nil
			Menu.visible = true
		end
	elseif Menu.visible == true then
		Menu:setAlpha(0)
		Menu.m_inputDisabled = true
		Menu.visible = nil
	end
	Menu:dispatchEventToChildren(ClientInstance)
end

CoD.PlayerHeadIcon.new = function(Menu, ObjectiveIndex)
	local waypoint = CoD.ObjectiveWaypoint.new(Menu, ObjectiveIndex, 0)
	waypoint:setClass(CoD.PlayerHeadIcon)
	waypoint:setEntityContainerClamp(false)
	waypoint:setLeftRight(false, false, -waypoint.iconWidth / 2, waypoint.iconWidth / 2)
	waypoint:setTopBottom(false, true, -waypoint.iconHeight, 0)
	waypoint.arrowImage:setAlpha(0)
	waypoint.mainImage:setLeftRight(false, false, -18, 18)
	waypoint.mainImage:setTopBottom(false, false, -18, 18)
	waypoint.disablePulse = true
	waypoint.updatePlayerUsing = CoD.NullFunction

	local objectiveName = Engine.GetObjectiveName(Menu, ObjectiveIndex)
	waypoint:registerEventHandler("objective_update_" .. objectiveName, waypoint.update)
	waypoint:registerEventHandler("hud_update_team_change", waypoint.update)
	waypoint:registerEventHandler("hud_update_other_player_team_change", waypoint.update)

	return waypoint
end

CoD.PlayerHeadIcon.update = function(Menu, ClientInstance)
	local index = Menu.index
	local controller = ClientInstance.controller
	local clientNum = Engine.GetPredictedClientNum(controller)
	local objectiveFlags = Engine.GetObjectiveGamemodeFlags(Menu, index)
	local objectiveEntity = Engine.GetObjectiveEntity(Menu, index)
	local clientTeam = Engine.GetTeamID(controller, clientNum)
	local objectiveEntityTeam = Engine.GetTeamID(controller, objectiveEntity)

	if objectiveFlags == CoD.PlayerWaypoint.FLAG_ALIVE and clientTeam == objectiveEntityTeam then
		local x, y, z = Engine.GetObjectivePosition(Menu, index)
		local gamemodeGroup = UIExpression.DvarString(nil, "ui_zm_gamemodegroup")
		local mapName = CoD.Zombie.GetUIMapName()
		local factionIcon = "faction_" .. Engine.GetFactionForTeam(objectiveEntityTeam)

		if gamemodeGroup == CoD.Zombie.GAMETYPEGROUP_ZCLASSIC then
			if mapName == CoD.Zombie.MAP_ZM_TOMB then
				factionIcon = "faction_tomb"
			elseif mapName == CoD.Zombie.MAP_ZM_BURIED then
				factionIcon = "faction_buried"
			elseif mapName == CoD.Zombie.MAP_ZM_PRISON then
				factionIcon = "faction_prison"
			elseif mapName == CoD.Zombie.MAP_ZM_HIGHRISE then
				factionIcon = "faction_highrise"
			else
				factionIcon = "faction_tranzit"
			end
		elseif gamemodeGroup == CoD.Zombie.GAMETYPEGROUP_ZSURVIVAL then
			if CoD.Zombie.IsSurvivalUsingCIAModel == true then
				if mapName == CoD.Zombie.MAP_ZM_PRISON then
					factionIcon = "faction_inmates"
				else
					factionIcon = "faction_cia"
				end
			end
		elseif gamemodeGroup == CoD.Zombie.GAMETYPEGROUP_ZENCOUNTER then
			if Dvar.ui_gametype:get() == CoD.Zombie.GAMETYPE_ZCLEANSED and objectiveEntityTeam == CoD.TEAM_AXIS then
				factionIcon = "faction_zombie"
			end
		end

		Menu.alphaController:setAlpha(1)
		Menu.mainImage:setImage(RegisterMaterial(factionIcon))
		Menu.zOffset = z
	else
		Menu.alphaController:setAlpha(0)
	end

	CoD.PlayerHeadIcon.super.update(Menu, ClientInstance)
end
