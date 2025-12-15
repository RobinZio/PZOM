function CheckDrops(zombie)
	if not zombie:getOutfitName() then return false end
	local outfit = tostring(zombie:getOutfitName());
	local inv = zombie:getInventory();
	if outfit == "TheyKnew_Hazmat" then
		--Zomboxolone
		local lootchance = SandboxVars.TheyKnew.ZomboxoloneLootChance;
		if lootchance >= ZombRand(1, 100) then
			inv:AddItems("TheyKnew.Zomboxolone", 1);
		end
		--Zomboxycycline
		local lootchance2 = SandboxVars.TheyKnew.ZomboxycyclineLootChance;
		if lootchance2 >= ZombRand(1, 100) then
			inv:AddItems("TheyKnew.Zomboxycycline", 1);
		end
		--Zomboxivir
		local lootchance3 = SandboxVars.TheyKnew.ZomboxivirLootChance;
		if lootchance3 >= ZombRand(1, 100) then
			inv:AddItems("TheyKnew.Zomboxivir", 1);
		end
	end
end

Events.OnZombieDead.Add(CheckDrops);