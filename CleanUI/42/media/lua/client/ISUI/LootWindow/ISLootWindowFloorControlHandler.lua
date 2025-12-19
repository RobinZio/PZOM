--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "ISBaseObject"
require "ISUI/ISButton"

ISLootWindowFloorControlHandler = ISBaseObject:derive("ISLootWindowFloorControlHandler")

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)

function ISLootWindowFloorControlHandler:shouldBeVisible()
    return false
end

function ISLootWindowFloorControlHandler:getControl()
    -- Default control is a button.  Could be a combobox, slider, etc.
    return self:getButtonControl("Button")
end

function ISLootWindowFloorControlHandler:getButtonControl(title)
    if not self.control then
        local buttonHeight = math.floor(FONT_HGT_SMALL * 1.2)
        self.control = CleanUI_LongButton:new(0, 0, 200, buttonHeight, "", self,
            function(_self, _button) _self:perform() end)
        if self.altColor then
            self.control:setActive(true)
            self.control:setActiveColor(0.6, 0.3, 0.1)
        end
    end
    self.control:setTitle(title)
    local padding = math.floor(FONT_HGT_SMALL * 0.4)
    local textWid = math.floor(getTextManager():MeasureStringX(UIFont.Small, title) + padding * 2)
    self.control:setWidth(textWid)
    return self.control
end

function ISLootWindowFloorControlHandler:handleJoypadContextMenu(context)
end

function ISLootWindowFloorControlHandler:addJoypadContextMenuOption(context, text)
    local option = context:addOption(text, self, self.perform)
    return option
end

function ISLootWindowFloorControlHandler:perform()
end

function ISLootWindowFloorControlHandler:new()
    local o = ISBaseObject.new(self)
    return o
end
