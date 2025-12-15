if TheyKnew == nil then TheyKnew = {} end

TheyKnew.ZomboxoloneTakePills = function (food, player, percent)
	local bodyDamage = player:getBodyDamage()
	local infected = bodyDamage:IsInfected()
	if infected then
		bodyDamage:setInfected(true)
		bodyDamage:setInfectionMortalityDuration(-1)
		bodyDamage:setInfectionTime(-1)
		bodyDamage:setInfectionLevel(0)
		local bodyParts = bodyDamage:getBodyParts()
		for i=bodyParts:size()-1, 0, -1  do
			local bodyPart = bodyParts:get(i)
			bodyPart:SetInfected(true)
		end
		bodyDamage:setInfected(true)
		bodyDamage:setInfectionLevel(0)
		HaloTextHelper.addText(player, getText("UI_ZomboxoloneBuff"))
	else
		HaloTextHelper.addBadText(player, getText("UI_ZomboxoloneNotInfected"))
	end
end

TheyKnew.ZomboxycyclineTakePills = function (food, player, percent)
	local playerdata = player:getModData()
	local playerBody = player:getBodyDamage()
	playerdata.ZomboxycyclineHours = 24
	playerdata.Zomboxycycline = true
	playerdata.ShouldBeInfected = playerBody:IsInfected();
	HaloTextHelper.addText(player, getText("UI_ZomboxycyclineBuff"))
end

TheyKnew.MonitorBuffs = function (player)
	local playerdata = player:getModData()
	local playerBody = player:getBodyDamage()
	--Sanity Check
	if playerdata.ZomboxoloneHours == nil then
		playerdata.ZomboxoloneHours = 0
	end
	if playerdata.ZomboxycyclineHours == nil then
		playerdata.ZomboxycyclineHours = 0
	end
	if playerdata.ZomboxycyclineHours > 0 then
		TheyKnew.ZomboxycyclineBuff(player)
	end
end

TheyKnew.ZomboxycyclineBuff = function (player)
	local playerdata = player:getModData()
	local playerBody = player:getBodyDamage()
	local infectionStatus = playerBody:IsInfected()
	if playerdata.ZomboxycyclineHours > 0 and infectionStatus and not playerdata.ShouldBeInfected then
		print("Player Infected, Zomboxycycline taking effect.")
		local bodyParts = playerBody:getBodyParts()
		for i=bodyParts:size()-1, 0, -1  do
			local bodyPart = bodyParts:get(i)
			bodyPart:SetInfected(false)
		end
		playerBody:setInfected(false)
        playerBody:setInfectionLevel(0)
		playerBody:setInfectionTime(-1)
		--verify
		if playerBody:IsInfected() == false then
			print("Infection Removed")
		end
	end
end

TheyKnew.RemoveBuff = function (_buff, _player)
	local uiString = string.format("UI_%sBuffExpire", _buff)
	playerdata = _player:getModData()
	playerdata[_buff] = false
	HaloTextHelper.addBadText(_player, getText(uiString))
end

TheyKnew.BuffTick = function ()
	local player = getPlayer()
	local playerdata = player:getModData()
	--Zomboxycycline
	if not(playerdata.ZomboxycyclineHours == nil) and playerdata.ZomboxycyclineHours >0 then
		playerdata.ZomboxycyclineHours = playerdata.ZomboxycyclineHours -1
		print("Zomboxycycline is still active.")
	elseif playerdata.ZomboxycyclineHours == 0  and playerdata.Zomboxycycline == true then
		TheyKnew.RemoveBuff("Zomboxycycline", player)
	end
end

TheyKnew.OnEat_Zomboxivir = function (food, player, percent)
	local playerdata = player:getModData()
	local bodyDamage = player:getBodyDamage();
	bodyDamage:setInfected(false);
	bodyDamage:setInfectionMortalityDuration(-1);
	bodyDamage:setInfectionTime(-1);
	bodyDamage:setInfectionLevel(0);
	local bodyParts = bodyDamage:getBodyParts();
	for i=bodyParts:size()-1, 0, -1  do
		local bodyPart = bodyParts:get(i);
		bodyPart:SetInfected(false);
	end
	bodyDamage:setInfected(false);
    bodyDamage:setInfectionLevel(0);
	--verify
	if bodyDamage:IsInfected() == false then
		print("Infection Removed");
	end
	--case for Zomboxydine
	if playerdata.ShouldBeInfected ~= nil then
		playerdata.ShouldBeInfected = false;
	end
end

Events.OnPlayerUpdate.Add(TheyKnew.MonitorBuffs)
Events.EveryHours.Add(TheyKnew.BuffTick)