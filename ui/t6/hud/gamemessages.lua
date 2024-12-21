CoD.GameMessages = {}
CoD.GameMessages.ObituraryWindowIndex = 0
CoD.GameMessages.BoldGameMessagesWindowIndex = 1
CoD.GameMessages.ObituaryWindowUpdateVisibility = function(ObituaryWidget, ClientInstance)
	if UIExpression.IsVisibilityBitSet(ClientInstance.controller, CoD.BIT_HUD_OBITUARIES) == 1 and UIExpression.IsVisibilityBitSet(ClientInstance.controller, CoD.BIT_UI_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(ClientInstance.controller, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(ClientInstance.controller, CoD.BIT_IN_KILLCAM) == 0 and UIExpression.IsVisibilityBitSet(ClientInstance.controller, CoD.BIT_IS_SCOPED) == 0 and (not CoD.IsShoutcaster(ClientInstance.controller) or CoD.ExeProfileVarBool(ClientInstance.controller, "shoutcaster_killfeed")) then
		ObituaryWidget:setAlpha(1)
	else
		ObituaryWidget:setAlpha(0)
	end
end

CoD.GameMessages.AddObituaryWindow = function(HUDWidget, MenuBase)
	local ObituaryWidget = LUI.UIElement.new(MenuBase)
	ObituaryWidget:setupGameMessages(CoD.GameMessages.ObituraryWindowIndex)
	ObituaryWidget:setAlignment(LUI.Alignment.Left)
	ObituaryWidget:setFont(CoD.fonts.ExtraSmall)
	ObituaryWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.GameMessages.ObituaryWindowUpdateVisibility)
	ObituaryWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_OBITUARIES, CoD.GameMessages.ObituaryWindowUpdateVisibility)
	ObituaryWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.GameMessages.ObituaryWindowUpdateVisibility)
	ObituaryWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_KILLCAM, CoD.GameMessages.ObituaryWindowUpdateVisibility)
	ObituaryWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.GameMessages.ObituaryWindowUpdateVisibility)
	ObituaryWidget:registerEventHandler("hud_update_refresh", CoD.GameMessages.ObituaryWindowUpdateVisibility)
	HUDWidget:addElement(ObituaryWidget)
end

CoD.GameMessages.BoldGameMessagesWindowUpdateVisibility = function(BoldGameMessageWidget, ClientInstance)
	if UIExpression.IsVisibilityBitSet(ClientInstance.controller, CoD.BIT_HUD_OBITUARIES) == 1 and UIExpression.IsVisibilityBitSet(ClientInstance.controller, CoD.BIT_UI_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(ClientInstance.controller, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(ClientInstance.controller, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(ClientInstance.controller, CoD.BIT_IN_KILLCAM) == 0 then
		BoldGameMessageWidget:setAlpha(1)
	else
		BoldGameMessageWidget:setAlpha(0)
	end
end

CoD.GameMessages.BoldGameMessagesWindow = function(HUDWidget, MenuBase)
	local BoldGameMessageWidget = CoD.SplitscreenScaler.new(MenuBase, 1.5)
	BoldGameMessageWidget:setupGameMessages(CoD.GameMessages.BoldGameMessagesWindowIndex)
	BoldGameMessageWidget:setAlignment(LUI.Alignment.Center)
	BoldGameMessageWidget:setFont(CoD.fonts.Default)
	BoldGameMessageWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.GameMessages.BoldGameMessagesWindowUpdateVisibility)
	BoldGameMessageWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_OBITUARIES, CoD.GameMessages.BoldGameMessagesWindowUpdateVisibility)
	BoldGameMessageWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.GameMessages.BoldGameMessagesWindowUpdateVisibility)
	BoldGameMessageWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_KILLCAM, CoD.GameMessages.BoldGameMessagesWindowUpdateVisibility)
	BoldGameMessageWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.GameMessages.BoldGameMessagesWindowUpdateVisibility)
	HUDWidget:addElement(BoldGameMessageWidget)
end
