-- Huge thanks to Dislaik for creating this method, you should him out: https://steamcommunity.com/sharedfiles/filedetails/?id=2728300240

local function MCF1_Enter(player)
	local vehicle = player:getVehicle()
	if not vehicle then return end
    local vehicleName = vehicle:getScriptName()
    local seat = vehicle:getSeat(player)
    if not seat then return end
	if seat == 0 and vehicleName:contains("Base.McLarenF1") then				
		player:SetVariable("VehicleScriptName", "Bob_IdleDriver")
		return
	end
	if seat == 1 and vehicleName:contains("Base.McLarenF1") then
		player:SetVariable("VehicleScriptName", "Bob_IdlePassenger")
		return
	end
	if seat == 2 and vehicleName:contains("Base.McLarenF1") then
		player:SetVariable("VehicleScriptName", "Bob_IdlePassenger")
		return
	end
end

function MCF1_Enter_Server(player)
	MCF1_Enter(player)
end

local function MCF1_Exit(player)
    sendClientCommand(player, "McLarenF1", "PlayerExit", {})
    player:SetVariable("VehicleScriptName", "")
end

Events.OnEnterVehicle.Add(MCF1_Enter)
Events.OnExitVehicle.Add(MCF1_Exit)
Events.OnSwitchVehicleSeat.Add(MCF1_Enter)