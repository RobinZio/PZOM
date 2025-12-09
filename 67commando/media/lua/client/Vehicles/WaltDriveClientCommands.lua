local Commands = {}

function Commands.setCoolerOn(player, args)
	local vehicle = getVehicleById(args.id);
	local fridge = vehicle:getPartById("Fridge");
	print(fridge:getModData().coolerActive)
	local active = fridge:getModData().coolerActive;
	fridge:getModData().coolerActive = not active;
	if active then
		fridge:getItemContainer():setCustomTemperature(0.2)
		fridge:getItemContainer():setActive(true)
	else
		fridge:getItemContainer():setCustomTemperature(1)
		fridge:getItemContainer():setActive(false)
	end
	vehicle:transmitPartModData(fridge);
end

function Commands.setOvenOn(player, args)
	local vehicle = getVehicleById(args.id)
	local oven = vehicle:getPartById("Oven")
	local active = oven:getModData().ovenActive
	oven:getModData().ovenActive = not active
	if active then
		oven:getItemContainer():setCustomTemperature(2.0)
		oven:getItemContainer():setActive(true)
	else
		oven:getItemContainer():setCustomTemperature(1)
		oven:getItemContainer():setActive(false)
	end
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
		vehicle:transmitPartModData(part)
	else
		part:getItemContainer():setCustomTemperature(0.2)
		if not vehicle:isEngineRunning() then
			VehicleUtils.chargeBattery(vehicle, args.batteryChange * args.elapsedMinutes)
		end
	end
end

function Commands.updateCarOven(player, args)
	local vehicle = getVehicleById(args.id)
	local part = vehicle:getPartById("Oven")

	if part:getInventoryItem() and part:getItemContainer() and part:getItemContainer():isActive() then
		local currentTemp = part:getItemContainer():getTemprature()
		local maxTemp = 2.0

		if currentTemp < maxTemp then
			part:getItemContainer():setCustomTemperature(currentTemp + 0.05)
		elseif currentTemp > maxTemp then
			part:getItemContainer():setCustomTemperature(maxTemp)
		end
	end

	if part:getInventoryItem() and part:getItemContainer() and not part:getItemContainer():isActive() then
		local currentTemp = part:getItemContainer():getTemprature()
		local minTemp = 1.0

		if currentTemp > minTemp then
			part:getItemContainer():setCustomTemperature(currentTemp - 0.05)
		elseif currentTemp < minTemp then
			part:getItemContainer():setCustomTemperature(minTemp)
		end
	end
end

function Commands.useCarOven(player, args)
	print(args.part)
	local chr = getPlayerFromUsername(args.player)
	local vehicle = getVehicleById(args.id)
	local cont = vehicle:getPartById("Oven"):getItemContainer()

	if cont:isActive() then
		cont:setActive(false)
		chr:getEmitter():playSound("PZ_Switch")
	elseif vehicle:getBatteryCharge() < 0.00005 then

	else
		cont:setActive(true)
		VehicleUtils.chargeBattery(vehicle, -0.00005)
		chr:getEmitter():playSound("PZ_Switch")
	end
end

Events.OnServerCommand.Add(function(module, command, args)
	if not isClient() then return end
	if module == "WaltDrive" and Commands[command] then
		args = args or {}
		Commands[command](player, args)
	end
end)
