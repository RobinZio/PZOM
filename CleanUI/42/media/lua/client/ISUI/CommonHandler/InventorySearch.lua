require "ISBaseObject"
require "ISUI/ISTextEntryBox"

ISInventoryCommonHandler_InventorySearch = ISBaseObject:derive("ISInventoryCommonHandler_InventorySearch")
local Handler = ISInventoryCommonHandler_InventorySearch
local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)

function Handler:shouldBeVisible()
    if getCore():getGameMode() == "Tutorial" then return false end
    return true
end

function Handler:getControl()
    if not self.control then
        self:createSearchControl()
    end
    return self.control
end

function Handler:createSearchControl()
    local buttonHeight = math.floor(FONT_HGT_SMALL * 1.2)
    local searchBoxWidth = buttonHeight * 4
    
    local totalWidth = buttonHeight + searchBoxWidth
    
    -- Panel
    self.control = ISPanel:new(0, 0, totalWidth, buttonHeight)
    self.control:initialise()
    self.control.prerender = function(panel)

        NeatTool.ThreePatch.drawHorizontal(panel, 0, 0, panel.width, panel.height,
        getTexture("media/ui/CleanUI/Button/LongBackground_L.png"),
        getTexture("media/ui/CleanUI/Button/LongBackground_M.png"),
        getTexture("media/ui/CleanUI/Button/LongBackground_R.png"),
        0.6, 0.1, 0.1, 0.1)

        NeatTool.ThreePatch.drawHorizontal(panel, 0, 0, panel.width, panel.height,
        getTexture("media/ui/CleanUI/Button/LongBorder_L.png"),
        getTexture("media/ui/CleanUI/Button/LongBorder_M.png"),
        getTexture("media/ui/CleanUI/Button/LongBorder_R.png"),
        1, 0.4, 0.4, 0.4)
        

        local text = self.searchField:getInternalText()
        if not self.searchField:isFocused() and text and text == "" then
            local iconSize = math.floor(panel.height * 0.8)
            local offset = (panel.height - iconSize) / 2
            panel:drawTextureScaled(getTexture("media/ui/CleanUI/ICON/Icon_Search.png"), offset, offset, iconSize, iconSize, 1, 0.7, 0.7, 0.7)
        end
    end
    
    -- TextEntryBox
    self.searchField = ISTextEntryBox:new("", 2, 0, searchBoxWidth, buttonHeight)
    self.searchField.backgroundColor.a = 0
    self.searchField.borderColor.a = 0
    self.searchField:initialise()
    self.searchField:setFont(UIFont.Small)
    self.searchField.onTextChange = function()
        self:onSearchTextChange()
        local text = self.searchField:getInternalText()
        self.clearButton:setVisible(text and text ~= "")
    end
    self.searchField:setVisible(true)
    self.control:addChild(self.searchField)
    
    -- ClearButton
    self.clearButton = ISButton:new(buttonHeight + searchBoxWidth - buttonHeight, 0, buttonHeight, buttonHeight, "", self,
        function(_self) _self:clearSearch() end
    )
    self.clearButton:initialise()
    self.clearButton.prerender = function(button)
        local iconSize = math.floor(button.height * 0.8)
        local offset = (button.height - iconSize) / 2
        button:drawTextureScaled(getTexture("media/ui/CleanUI/ICON/Icon_Close.png"), offset, offset, iconSize, iconSize, 1, 0.7, 0.7, 0.7)
    end
    self.clearButton:setVisible(false)
    self.control:addChild(self.clearButton)
    
    self.control:setWidth(totalWidth)
end

function Handler:getWindow()
    return self.inventoryWindow or self.lootWindow
end

function Handler:onSearchTextChange()
    local searchText = self.searchField:getInternalText()
    local window = self:getWindow()
    
    if window and window.inventoryPane then
        if searchText and searchText ~= "" then
            window.inventoryPane:searchContainer(searchText)
        else
            window.inventoryPane:clearSearch()
        end
    end
end

function Handler:clearSearch()
    self.searchField:setText("")
    self.clearButton:setVisible(false)
    local window = self:getWindow()
    
    if window and window.inventoryPane then
        window.inventoryPane:clearSearch()
    end
    self.searchField:focus()
end

function Handler:perform()
    self.searchField:focus()
end

-- ----------------------------------------------------------------------------------------------------- --
-- Temp move the TransferMenu here for joypad
-- ----------------------------------------------------------------------------------------------------- --
function Handler:showTransferMenu()
    local window = self:getWindow()
    if not window then return end

    local x = self.control:getAbsoluteX()
    local y = self.control:getAbsoluteY() + self.control:getHeight()

    local context = ISInventoryPageTransferHandler.showTransferMenu(window, x, y)

    if context and JoypadState.players[self.playerNum + 1] then
        context.origin = window
        context.mouseOver = 1
        setJoypadFocus(self.playerNum, context)
    end
end

function Handler:handleJoypadContextMenu(context)
    context:addOption(getText("UI_CleanUI_TransferMenu"), self, self.showTransferMenu)
    
    return context
end

function Handler:addJoypadContextMenuOption(context, text)
    local option = context:addOption(text, self, self.perform)
    return option
end

function Handler:new()
    local o = ISBaseObject.new(self)
    o.altColor = false
    return o
end