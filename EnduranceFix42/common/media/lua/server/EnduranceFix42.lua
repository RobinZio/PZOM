-- EnduranceFix42.lua
-- Server-side companion (B42 MP)

if not isServer() then return end

require "EnduranceFix42State"
require "EnduranceFix42Config"
require "EnduranceFix42Detector"

EnduranceFix42 = EnduranceFix42 or {}
EnduranceFix42.Clients = EnduranceFix42.Clients or {}
EnduranceFix42.Warned = EnduranceFix42.Warned or {}

--------------------------------------------------
-- Startup status
--------------------------------------------------
Events.OnServerStarted.Add(function()
    if EnduranceFix42.State.isDisabled() then
        print("[EnduranceFix42] Disabled (native endurance recovery detected)")
    else
        print("[EnduranceFix42] Server companion active")
    end
end)

--------------------------------------------------
-- Client handshake
--------------------------------------------------
Events.OnClientCommand.Add(function(module, command, player, args)
    if module ~= "EnduranceFix42" then return end
    if command == "Hello" then
        EnduranceFix42.Clients[player:getUsername()] = true
        print("[EnduranceFix42] Client handshake received from " .. player:getUsername())
    end
end)

local function checkClients()
    local players = getOnlinePlayers()
    if not players then return end

    for i = 0, players:size() - 1 do
        local player = players:get(i)
        local name = player:getUsername()
        if not EnduranceFix42.Clients[name] and not EnduranceFix42.Warned[name] then
            print("[EnduranceFix42][WARN] Client mod missing for: " .. name)
            EnduranceFix42.Warned[name] = true
        end
    end
end

Events.EveryMinutes.Add(checkClients)

--------------------------------------------------
-- Optional detection / future-proof logic
--------------------------------------------------
local function tick()
    if EnduranceFix42.State.isDisabled() then return end

    local players = getOnlinePlayers()
    if not players then return end

    for i = 0, players:size() - 1 do
        local player = players:get(i)
        if player then
            EnduranceFix42.Detector.sample(player)
        end
    end

    if EnduranceFix42.AutoDisable
        and EnduranceFix42.Detector.shouldDisable() then
        EnduranceFix42.Detector.disable()
    end
end

Events.EveryTenSeconds.Add(tick)

--------------------------------------------------
-- Admin commands: /endurancefix status | reset | debug on|off
--------------------------------------------------
local function endurancefixCommand(player, command, args)
    if not player:isAdmin() then
        player:Say("You do not have permission to use this command.")
        return
    end

    local sub = args[1] and args[1]:lower() or ""

    if sub == "status" then
        local active = EnduranceFix42.State.isDisabled() and "Disabled" or "Active"
        local clients = {}
        for name,_ in pairs(EnduranceFix42.Clients) do
            table.insert(clients, name)
        end
        player:Say("[EnduranceFix42] Status: " .. active)
        player:Say("Clients with mod: " .. (table.concat(clients, ", ") ~= "" and table.concat(clients, ", ") or "None"))
    elseif sub == "reset" then
        EnduranceFix42.State.reset()
        EnduranceFix42.Detector.resetSamples()
        EnduranceFix42.Clients = {}
        EnduranceFix42.Warned = {}
        player:Say("[EnduranceFix42] Mod state reset. Active again.")
    elseif sub == "debug" then
        local toggle = args[2] and args[2]:lower()
        if toggle == "on" then
            EnduranceFix42.Debug = true
            player:Say("[EnduranceFix42] Debug logging enabled.")
        elseif toggle == "off" then
            EnduranceFix42.Debug = false
            player:Say("[EnduranceFix42] Debug logging disabled.")
        else
            player:Say("Usage: /endurancefix debug on|off")
        end
    else
        player:Say("EnduranceFix42 commands: status | reset | debug on|off")
    end
end

Commands.AddCommand("endurancefix", endurancefixCommand)
