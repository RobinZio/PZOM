-- EnduranceFix42State.lua
-- Handles persistent server state via ModData

if not isServer() then return end

EnduranceFix42 = EnduranceFix42 or {}
EnduranceFix42.State = EnduranceFix42.State or {}

local MODDATA_KEY = "EnduranceFix42"

local function getData()
    return ModData.getOrCreate(MODDATA_KEY)
end

function EnduranceFix42.State.isDisabled()
    return getData().disabled == true
end

function EnduranceFix42.State.setDisabled()
    local data = getData()
    data.disabled = true
    ModData.transmit(MODDATA_KEY)
end

function EnduranceFix42.State.reset()
    local data = getData()
    data.disabled = false
    ModData.transmit(MODDATA_KEY)
end
