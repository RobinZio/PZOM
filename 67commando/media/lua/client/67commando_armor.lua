require "DAMN_Armor_Shared";

--***********************************************************
--**                   KI5 / bikinihorst                   **
--***********************************************************
--v2.0.0

V100 = V100 or {};

function V100.activeArmor(player, vehicle)
   
		--

        for i, viewportPart in ipairs ({"Windshield", "WindshieldRear", "WindowFrontLeft", "WindowFrontRight", "WindowRearLeft", "WindowRearRight"})
        do
            if vehicle:getPartById(viewportPart) then
                local part = vehicle:getPartById(viewportPart)
                local viewportPart = 59;
                    if part:getCondition() < viewportPart then
                        DAMN.Armor:setPartCondition(part, viewportPart);
                    end
            end
        end

        --

            for i, doorPart in ipairs ({"DoorFrontLeft", "DoorFrontRight", "DoorRear", "V100ToolboxLid"})
                do
                    if vehicle:getPartById(doorPart) then
                        local part = vehicle:getPartById(doorPart)
                        local doorPart = 11;
                            if part:getCondition() < doorPart then
                                DAMN.Armor:setPartCondition(part, doorPart);
                            end
                    end
            end

        --

			for partId, armorPartId in pairs({
				["HeadlightLeft"] = "V100LightGuards",
				["HeadlightRight"] = "V100LightGuards",
			}) do
				local part = vehicle:getPartById(partId);
				local protection = vehicle:getPartById(armorPartId);
				if protection and protection:getInventoryItem() and part and part:getModData()
				then
					local partCond = tonumber(part:getModData().saveCond);
					if protection:getCondition() > 0 and partCond and part:getCondition() < partCond
					then
						DAMN.Armor:setPartCondition(part, partCond);
						local cond = protection:getCondition() - (ZombRandBetween(0,100) <= 70 and ZombRandBetween(0,3) or 0)
						DAMN.Armor:setPartCondition(protection, cond);
					end
				end
			end

        --

        for i, doorPart in ipairs ({"EngineDoor", "V100Toolbox"})
        do
            if vehicle:getPartById(doorPart) then
                local part = vehicle:getPartById(doorPart)
                local doorPart = 49;
                    if part:getCondition() < doorPart then
                        DAMN.Armor:setPartCondition(part, doorPart);
                    end
            end
        end

        for i, doorPart in ipairs ({"GasTank", "TruckBed"})
        do
            if vehicle:getPartById(doorPart) then
                local part = vehicle:getPartById(doorPart)
                local doorPart = 95;
                    if part:getCondition() < doorPart then
                        DAMN.Armor:setPartCondition(part, doorPart);
                    end
            end
        end

            local part = vehicle:getPartById("Engine")
				if part:getCondition() < 9 then
					DAMN.Armor:setPartCondition(part, 9);
				end
        --
end

DAMN.Armor:add("Base.67commando", V100.activeArmor);
DAMN.Armor:add("Base.67commandoT50", V100.activeArmor);
DAMN.Armor:add("Base.67commandoPolice", V100.activeArmor);