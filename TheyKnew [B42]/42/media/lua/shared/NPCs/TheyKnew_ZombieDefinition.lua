require 'NPCs/ZombiesZoneDefinition'

function CallSandboxVars()
	local hazmatSpawnChance = SandboxVars.TheyKnew.HazmatSpawnChance
	table.insert(ZombiesZoneDefinition.Default,{name = "TheyKnew_Hazmat", chance = hazmatSpawnChance})
	print("DING Gets Called")
	print(hazmatSpawnChance)
end

if isServer() then
    Events.OnServerStarted.Add(CallSandboxVars)
else
    Events.OnPostDistributionMerge.Add(CallSandboxVars);
end