-- EnduranceFix42Detector.lua
-- Tracks endurance and client handshakes

if not isServer() then return end

EnduranceFix42 = EnduranceFix42 or {}
EnduranceFix42.Detector = EnduranceFix42.Detector or {}
EnduranceFix42.Clients = EnduranceFix42.Clients or {}
EnduranceFix42.Warned = EnduranceFix42.Warned or {}

local samples = {}
local positiveSamples = 0

local function log(msg)
    if EnduranceFix42.Debug then
        print("[EnduranceFix42][Detector] " .. msg)
    end
end

-- Server-side detection
function EnduranceFix42.Detector.sample(player)
    local id = player:getOnlineID()
    local stats = player:getStats()
    if not stats then return end

    local current = stats:getEndurance()
    local prev = samples[id] or current

    if current > prev then
        positiveSamples = positiveSamples + 1
        log("Positive recovery sample (" .. positiveSamples .. ") from " .. player:getUsername())
    end

    samples[id] = current
end

function EnduranceFix42.Detector.shouldDisable()
    return positiveSamples >= EnduranceFix42.RequiredPositiveSamples
end

function EnduranceFix42.Detector.disable()
    EnduranceFix42.State.setDisabled()
    print("[EnduranceFix42] Native endurance recovery detected. Mod permanently disabled.")
end

-- Client handshake tracking
function EnduranceFix42.Detector.recordClient(player)
    EnduranceFix42.Clients[player:getUsername()] = true
end

-- Warn about missing clients
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

-- Handle client handshake
Events.OnClientCommand.Add(function(module, command, player, args)
    if module ~= "EnduranceFix42" then return end
    if command == "Hello" then
        print("[EnduranceFix42] Client mod detected: " .. player:getUsername())
        EnduranceFix42.Detector.recordClient(player)
    end
end)
