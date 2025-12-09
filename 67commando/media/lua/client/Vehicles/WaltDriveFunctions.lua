WaltFunctions = {};

--COOLER HERE DUDE
function WaltFunctions.onToggleCooler(playerObj)
	local vehicle = playerObj:getVehicle();
	local id = vehicle:getId();
	local fridgePart = vehicle:getPartById("Fridge");
	local active = fridgePart:getModData().coolerActive;
	if not vehicle then return end
	if isClient() then
		sendClientCommand(getPlayer(), 'WaltDrive', 'setCoolerOn', { id = id })
	else
		fridgePart:getModData().coolerActive = not active
		if active then
			fridgePart:getItemContainer():setCustomTemperature(0.2)
		else
			fridgePart:getItemContainer():setCustomTemperature(1)
		end
		vehicle:transmitPartModData(fridgePart) --Test for fridge
	end
end

--OVEN HERE DUDE
function WaltFunctions.onToggleOven(playerObj)
	local vehicle = playerObj:getVehicle();
	local id = vehicle:getId();
	local	oven = vehicle:getPartById("Oven");
	local active = oven:getModData().ovenActive;
	if not vehicle then return end
	if isClient() then
		sendClientCommand(getPlayer(), 'WaltDrive', 'setOvenOn', { id = id })
	else
		oven:getModData().ovenActive = not active
		if active then
			oven:getItemContainer():setCustomTemperature(2.0)
		else
			oven:getItemContainer():setCustomTemperature(1)
		end
		vehicle:transmitPartModData(oven) --Test for oven
	end
end
