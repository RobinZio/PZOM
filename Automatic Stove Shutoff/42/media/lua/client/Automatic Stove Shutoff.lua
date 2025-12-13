local CheckStove_Timer = {}
local AutomaticStoveShutoff_Checked = false
AutomaticStoveShutoff = {}

--[[
local AutomaticStoveShutoff_OvenUI = ISOvenUI.onClick
function ISOvenUI:onClick(button)
	if button.internal == "OK" then
		AutomaticStoveShutoff.Start(self.oven)
	end

	AutomaticStoveShutoff_OvenUI(self, button)
end
--]]

function ISOvenUI:onClick(button)
	if button.internal == "OK" then
		if instanceof(self.oven, "IsoStove") then
			AutomaticStoveShutoff.Start(self.oven)
		end
	end

	if button.internal == "CLOSE" then
		self:setVisible(false);
		self:removeFromUIManager();
		local player = self.character:getPlayerNum()
		if JoypadState.players[player+1] then
			setJoypadFocus(player, self.prevFocus)
		end
	end
	if button.internal == "OK" then
        self.oven:Toggle()
	end
end

--[[
local AutomaticStoveShutoff_MicrowaveUI = ISMicrowaveUI.onClick
function ISMicrowaveUI:onClick(button)
	if button.internal == "OK" then
		AutomaticStoveShutoff.Start(self.oven)
	end

	AutomaticStoveShutoff_MicrowaveUI(self, button)
end
--]]

function ISMicrowaveUI:onClick(button)
	if button.internal == "OK" then
		if instanceof(self.oven, "IsoStove") then
			AutomaticStoveShutoff.Start(self.oven)
		end
	end

	if button.internal == "CLOSE" then
		self:setVisible(false);
		self:removeFromUIManager();
		local player = self.character:getPlayerNum()
		if JoypadState.players[player+1] then
			setJoypadFocus(player, self.prevFocus)
		end
	end
	if button.internal == "OK" then
		self.oven:Toggle()
	end
end

local AutomaticStoveShutoff_ToggleStoveAction = ISToggleStoveAction.perform
function ISToggleStoveAction:perform()
	if instanceof(self.object, "IsoStove") then
		AutomaticStoveShutoff.Start(self.object)
	end

	AutomaticStoveShutoff_ToggleStoveAction(self)
end

local AutomaticStoveShutoff_ISInventoryPage = ISInventoryPage.toggleStove
function ISInventoryPage:toggleStove()
	if instanceof(self.inventoryPane.inventory:getParent(), "IsoStove") then
		AutomaticStoveShutoff.Start(self.inventoryPane.inventory:getParent())
	end

	AutomaticStoveShutoff_ISInventoryPage(self)
end

Events.OnGameStart.Add(function()
	if not getActivatedMods():contains("\\Project_Cook") then return end

	if PJCK_CookerPicker and PJCK_CookerPicker.onStoveButtonClick then
		local AutomaticStoveShutoff_PJCK_CookerPicker = PJCK_CookerPicker.onStoveButtonClick
		function PJCK_CookerPicker:onStoveButtonClick()
			if instanceof(self.CookerPanel.selectedCooker:getParent(), "IsoStove") then
				AutomaticStoveShutoff.Start(self.CookerPanel.selectedCooker:getParent())
			end

			AutomaticStoveShutoff_PJCK_CookerPicker(self)
		end
	end
end)

function AutomaticStoveShutoff.CheckStove(stove)
	if stove:Activated() then
		local allCooked = true
		for i = 0, stove:getContainer():getItems():size()-1 do
			local item = stove:getContainer():getItems():get(i)
				if item:isCookable() or item:hasTag("Cookable") then
					if item:IsFood() then
						if (item:isGoodHot() or item:isBadCold()) and item:getHeat() < 1.1 then
							item:setCookingTime(0)
						end
					end
					if item:getMinutesToCook() > item:getCookingTime() and item:getCookingTime() >= 0 and item:IsFood() then
						allCooked = false
					elseif item:isCooked() and item:IsFood() then
						if not item:isFrozen() then
							item:setCookingTime(-300)
						end
					elseif item:IsFood() then
						allCooked = false
					elseif item:getFluidContainer() then
						if not item:getFluidContainer():isEmpty() then
							allCooked = false
						end
					end
				end
			if item:IsFood() then
				if item:isFrozen() then
					allCooked = false
				end
			end
			if stove:getContainer():getType() == "microwave" then
				stove:setTimer(60)
			end
			if stove:getContainer():getType() == "microwave" and item:getFluidContainer() then
				if item:getFluidContainer():isTainted() then
					allCooked = false
				end
			end
			if item:isBurnt() then
				--stove:setActivated(false)
				stove:Toggle()
				getPlayer():Say(getText("IGUI_AutomaticStoveShutoff_Say3"))
				print("Stove Off")
				break
			end
			if stove:getContainer():getType() == "microwave" and (item:getMetalValue() > 0 or item:hasTag("HasMetal")) then
				--stove:setActivated(false)
				stove:Toggle()
				getPlayer():Say(getText("IGUI_AutomaticStoveShutoff_Say2"))
				print("Stove Off")
				break
			end
		end
		if allCooked then
			--stove:setActivated(false)
			stove:Toggle()
			print("Stove Off")
		end
	else
		setGameSpeed(1)
		Events.OnTick.Remove(CheckStove_Timer[stove])
		CheckStove_Timer[stove] = nil
		print("Event Remove")
	end

	if math.abs(stove:getSquare():getX() - getPlayer():getX()) >= 50 or math.abs(stove:getSquare():getY() - getPlayer():getY()) >= 50 then
		setGameSpeed(1)
		Events.OnTick.Remove(CheckStove_Timer[stove])
		CheckStove_Timer[stove] = nil
		getPlayer():Say(getText("IGUI_AutomaticStoveShutoff_Say1"))
		print("Event Remove")
	end

end

function AutomaticStoveShutoff.Start(stove)
	if CheckStove_Timer[stove] or stove:Activated() or AutomaticStoveShutoff_Checked then
		return
	end

	local function tick()
		AutomaticStoveShutoff.CheckStove(stove)
	end

	CheckStove_Timer[stove] = tick
	Events.OnTick.Add(tick)
	print("Event Add")

end


function AutomaticStoveShutoff.Context(player, context, worldobjects)
	for i = 0, worldobjects[1]:getSquare():getObjects():size()-1 do
		local tile = worldobjects[1]:getSquare():getObjects():get(i)
		if instanceof(tile, "IsoStove") then
			local option
			option = context:addOption(getText("ContextMenu_AutomaticStoveShutoffOnOff"), worldobjects, AutomaticStoveShutoff.OnOff, player)
			if AutomaticStoveShutoff_Checked then
				option.iconTexture = getTexture("media/textures/AutomaticStoveShutoff_Check.png")
			else
				option.iconTexture = nil
			end
			break
		end
	end
end

function AutomaticStoveShutoff.OnOff(worldobjects, player)
	if AutomaticStoveShutoff_Checked then
		AutomaticStoveShutoff_Checked = false
	else
		AutomaticStoveShutoff_Checked = true
	end
end

Events.OnFillWorldObjectContextMenu.Add(AutomaticStoveShutoff.Context)