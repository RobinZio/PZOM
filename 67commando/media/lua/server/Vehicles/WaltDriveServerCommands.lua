local Commands = {}

function Commands.setCoolerOn(player, args)
	local vehicle = getVehicleById(args.id)
	local trunk = vehicle:getPartById("Fridge")
	local active = trunk:getModData().coolerActive
	trunk:getModData().coolerActive = not active
	vehicle:transmitPartModData(trunk)
end

function Commands.setOvenOn(player, args)
	local vehicle = getVehicleById(args.id)
	local oven = vehicle:getPartById("Oven")
	local active = oven:getModData().ovenActive
	oven:getModData().ovenActive = not active
	vehicle:transmitPartModData(oven)
end

function Commands.startTrunkFridge(player, args)
	args.part:getModData().coolerActive = true
	args.part:getItemContainer():setCustomTemperature(0.2)
end

function Commands.updateCarFridge(player, args)
	local vehicle = getVehicleById(args.id)
	local part = vehicle:getPartById("Fridge")
	if vehicle:getBatteryCharge() <= 0.0 then
		part:getModData().coolerActive = false
	else
		part:getItemContainer():setCustomTemperature(0.2)
		if not vehicle:isEngineRunning() then
			VehicleUtils.chargeBattery(vehicle, args.batteryChange * args.elapsedMinutes)
		end
	end
	vehicle:transmitPartModData(part)
end

function Commands.updateCarOven(player, args)
	local vehicle = getVehicleById(args.id)
	local part = vehicle:getPartById("Oven")

	if part:getInventoryItem() and part:getItemContainer() then
		if part:getItemContainer():isActive() then
			local currentTemp = part:getItemContainer():getTemperature()
			local maxTemp = 2.0

			if currentTemp < maxTemp then
				part:getItemContainer():setCustomTemperature(currentTemp + 0.05)
			elseif currentTemp > maxTemp then
				part:getItemContainer():setCustomTemperature(maxTemp)
			end
		elseif not part:getItemContainer():isActive() then
			local currentTemp = args.part:getItemContainer():getTemperature()
			local minTemp = 1.0

			if currentTemp > minTemp then
				part:getItemContainer():setCustomTemperature(currentTemp - 0.05)
			elseif currentTemp < minTemp then
				part:getItemContainer():setCustomTemperature(minTemp)
			end
		end
		vehicle:transmitPartModData(part)
	end
end

function Commands.useCarOven(player, args)
	local vehicle = getVehicleById(args.id)
	part = vehicle:getPartById("Oven"):getItemContainer()

	if part:isActive() then
		part:setActive(false)
		player:getEmitter():playSound("PZ_Switch")
	elseif vehicle:getBatteryCharge() < 0.00005 then

	else
		part:setActive(true)
		VehicleUtils.chargeBattery(vehicle, -0.00005)
		player:getEmitter():playSound("PZ_Switch")
	end
end

Events.OnClientCommand.Add(function(module, command, player, args)
	if module == 'WaltDrive' and Commands[command] then
		args = args or {}
		Commands[command](player, args)
    		sendServerCommand(module, command, args)
	end
end)
