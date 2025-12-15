-- EnduranceFix42Client.lua
-- CLIENT-SIDE stamina control (B42 MP)

if isServer() then return end

-- Config
local RECOVERY_RATE = 0.015

-- Track if player can recover
local function canRecover(player)
    return
        not player:isRunning() and
        not player:isSprinting() and
        not player:isAiming() and
        not player:isAttacking() and
        not player:isClimbing() and
        player:getVehicle() == nil
end

-- Player endurance tick
Events.OnPlayerUpdate.Add(function(player)
    if not player then return end
    local stats = player:getStats()
    if not stats then return end

    local endurance = stats:getEndurance()
    if endurance < 1.0 and canRecover(player) then
        stats:setEndurance(math.min(1.0, endurance + RECOVERY_RATE))
    end
end)

-- Handshake with server on game start
Events.OnGameStart.Add(function()
    sendClientCommand("EnduranceFix42", "Hello", {})
end)
