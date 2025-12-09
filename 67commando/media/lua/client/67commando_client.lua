--***********************************************************
--**     KI5 did this / bikinihorst is not to blame        **
--***********************************************************

DAMN = DAMN or {};
V100 = V100 or {};

function V100.pvFixCheck()
	local vanillaEnter = ISEnterVehicle["start"];

	ISEnterVehicle["start"] = function(self)

		local vehicle = self.vehicle
			if 	vehicle and (
				string.find( vehicle:getScriptName(), "67commando" )) then

				self.character:SetVariable("damnVehicle", "True")
			end
		
	vanillaEnter(self);
		
		local seat = self.seat
    		if not seat then return end
				if seat == 0 then		
					self.character:SetVariable("damnPosition", "driver")
				else		
					self.character:SetVariable("damnPosition", "passenger")
			end
	end
end

function V100.pvFixSwitch(player)
	local player = getPlayer()
	local vehicle = player:getVehicle()
		if 	vehicle and (
			string.find( vehicle:getScriptName(), "67commando" )) then

			player:SetVariable("damnVehicle", "True")

			local seat = vehicle:getSeat(player)
	    		if not seat then return end
					if seat == 0 then		
						player:SetVariable("damnPosition", "driver")
					else
						player:SetVariable("damnPosition", "passenger")
					end

	end
end

function V100.pvFixFallback(player)
	local player = getPlayer()
	local vehicle = player:getVehicle()
		if vehicle and (
			string.find( vehicle:getScriptName(), "67commando" )) then

			player:SetVariable("damnVehicle", "True")

			local seat = vehicle:getSeat(player)
	    		if not seat then return end
					if seat == 0 then		
						player:SetVariable("damnPosition", "driver")
					else
						player:SetVariable("damnPosition", "passenger")
					end

	end
end

function V100.pvFixClear(player)

		player:SetVariable("damnVehicle", "False")
end

Events.OnPlayerUpdate.Add(V100.pvFixFallback);
Events.OnGameStart.Add(V100.pvFixCheck);
Events.OnGameStart.Add(V100.pvFixSwitch);
Events.OnExitVehicle.Add(V100.pvFixClear);
Events.OnSwitchVehicleSeat.Add(V100.pvFixSwitch);