---
--- Created by cytt0rak
---  WIP

function McLarenF1WindowFrontLeft(player, part, elapsedMinutes)
    local vehicle = player:getVehicle()
    if (vehicle and string.find( vehicle:getScriptName(), "McLarenF1" )) then

        local part = vehicle:getPartById("WindowFrontLeft")
        if (vehicle:getPartById("McLarenF1FrontLeftWindowArmor"):getCondition() > 1) and (vehicle:getPartById("WindowFrontLeft"):getCondition() < 70) and (vehicle:getPartById("McLarenF1FrontLeftWindowArmor"):getInventoryItem()) then

            sendClientCommand(player, "vehicle", "setPartCondition", { vehicle = vehicle:getId(), part = part:getId(), condition = 70 })
            vehicle:getPartById("McLarenF1FrontLeftWindowArmor"):setCondition(vehicle:getPartById("McLarenF1FrontLeftWindowArmor"):getCondition()-1)

        end
        vehicle:transmitPartModData(WindowFrontLeft)
    end


end

function McLarenF1WindowFrontRight(player, part, elapsedMinutes)
    local vehicle = player:getVehicle()
    if (vehicle and string.find( vehicle:getScriptName(), "McLarenF1" )) then

        local part = vehicle:getPartById("WindowFrontRight")
        if (vehicle:getPartById("McLarenF1FrontRightWindowArmor"):getCondition() > 1) and (vehicle:getPartById("WindowFrontRight"):getCondition() < 70) and (vehicle:getPartById("McLarenF1FrontRightWindowArmor"):getInventoryItem()) then


            sendClientCommand(player, "vehicle", "setPartCondition", { vehicle = vehicle:getId(), part = part:getId(), condition = 70 })
            vehicle:getPartById("McLarenF1FrontRightWindowArmor"):setCondition(vehicle:getPartById("McLarenF1FrontRightWindowArmor"):getCondition()-1)

        end
        vehicle:transmitPartModData(WindowFrontRight)
    end


end

function McLarenF1Bullbar(player, part, elapsedMinutes)
    local vehicle = player:getVehicle()
    if (vehicle and string.find( vehicle:getScriptName(), "McLarenF1" )) then

local part = vehicle:getPartById("EngineDoor")
        if (vehicle:getPartById("McLarenF1Bullbar"):getCondition() > 1) and (vehicle:getPartById("EngineDoor"):getCondition() < 70) and (vehicle:getPartById("McLarenF1Bullbar"):getInventoryItem()) then

            sendClientCommand(player, "vehicle", "setPartCondition", { vehicle = vehicle:getId(), part = part:getId(), condition = 100 })
            vehicle:getPartById("McLarenF1Bullbar"):setCondition(vehicle:getPartById("McLarenF1Bullbar"):getCondition()-1)

        end
        vehicle:transmitPartModData(EngineDoor)
    end


end


Events.OnPlayerUpdate.Add(McLarenF1WindowFrontLeft);
Events.OnPlayerUpdate.Add(McLarenF1WindowFrontRight);
Events.OnPlayerUpdate.Add(McLarenF1Bullbar);