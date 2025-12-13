require "AutoCook"

function AutoCook.initAutoCraftRecipes()
    local allRecipes = getScriptManager():getAllCraftRecipes()
    local count = 0
    if AutoCook.Verbose then print('initAutoCraftRecipes '..allRecipes:size()) end
    for i=0,allRecipes:size()-1 do
        local recipe = allRecipes:get(i);
        --if AutoCook.Verbose then print('initAutoCraftRecipes '..i..' '..tab2str(recipe:getName())) end
        if recipe:isEnabled() and isDebugEnabled() or not recipe:isDebugOnly() and not recipe:getObsolete() then
            local someFoodSource = false
            ----take only packaged food as source
            --local sources = recipe:getInputs()
            --for sourceIt=0, sources:size()-1 do
            --    local source = sources:get(sourceIt)
            --    if AutoCook.Verbose then print('initAutoCraftRecipes '..i..' source '..sourceIt..' '..tab2str(source)) end
            --    local items = source:getItems()
            --    for itemIt2=0, items:size()-1 do
            --        local itemStr = items:get(itemIt2)
            --        local item = getScriptManager():getItem(itemStr)
            --        if item and item:getTypeString() == 'Food' and not item:isCantEat() then--no access to Item.Type.Food ?!
            --            --if AutoCook.Verbose then print('initAutoCraftRecipes rejected: '..recipe:getName()..' for '..itemStr) end
            --            someFoodSource = true
            --            break
            --        end
            --    end
            --    if someFoodSource then break end
            --end
            --ensure unpack result is auto-edible
            local validResultItem = false
            if not someFoodSource then
                local outputs = recipe:getOutputs()
                for outputIt=0, outputs:size()-1 do
                    local outputScript = outputs:get(outputIt)
                    if outputScript:getResourceType() == ResourceType.Item then
                        local itemList = outputScript:getPossibleResultItems()
                        for itemIt=0, itemList:size()-1 do
                            local item = itemList:get(itemIt)
                            if item and item:isItemType(ItemType.Food)  and item:getHungerChange() < 0 then-- result should be food with beneficial effect on hunger
                                --if AutoCook.Verbose then print('initAutoCraftRecipes '..i..' result '..outputIt..' '..itemIt..' '..tab2str(item:getFullName())) end
                                AutoCook.AutoCraftRecipes[item:getFullName()] = recipe
                                count = count + 1
                                if AutoCook.Verbose then print('initAutoCraftRecipes include: '..recipe:getName()..' from '..item:getFullName()) end
                            else
                                --if AutoCook.Verbose then print('initAutoCraftRecipes rejected for not edible result: '..recipe:getName()..' for '..resultType) end
                            end
                        end
                    end
                end
            end
        end
    end
    if AutoCook.Verbose then print('initAutoCraftRecipes loaded: '..count) end
end

function AutoCook.getPossibleCraftedFoodTypes(player, recipe, containers, exclude)
    local result = {}
    local mapReduc = {}
    -- check all recipe items that end with "Open" and return all available in containers
    for i=0,recipe:getPossibleItems():size()-1 do
        local itemType = recipe:getPossibleItems():get(i):getFullType()
        -- skip if excluded
        if itemType and (not exclude or not exclude[itemType]) then
            -- if we have a recipe to retrieve the valid ingredient
            local openCanRecipe = AutoCook.AutoCraftRecipes[itemType]
            if openCanRecipe then
                if CraftRecipeManager.isValidRecipeForCharacter(openCanRecipe, player, nil) and AutoCook.isCraftRecipeInputAvailable(openCanRecipe, player) then--todo check inventory is available
                    if mapReduc[itemType] == nil then
                        mapReduc[itemType] = true
                        table.insert(result, itemType)
                        if AutoCook.Verbose then print ("AutoCook.getPossibleCraftedFoodTypes: found possible crafted food " .. itemType.." from craftRecipe "..tostring(openCanRecipe)) end
                    end
                end
            end
        end
    end
    return result
end

function AutoCook.isCraftRecipeInputAvailable(craftRecipe, player)
    local inputs = craftRecipe:getInputs()
    for sourceIt=0, inputs:size()-1 do
        local inputScript = inputs:get(sourceIt)
        if inputScript:getResourceType() == ResourceType.Item then
            local itemList = inputScript:getPossibleInputItems()
            local gotOne = false
            for itemIt=0, itemList:size()-1 do
                local item = itemList:get(itemIt)
                local inventoryItem = player:getInventory():getFirstTypeRecurse(item:getFullName());
                if inventoryItem then
                    if AutoCook.Verbose then print('isCraftRecipeInputAvailable '..tab2str(craftRecipe:getName())..' '..sourceIt..' input '..itemIt..' '..tab2str(item)..' amount='..tostring(inputScript:getAmount())) end
                    gotOne = true
                    break
                end
            end
            if not gotOne then return false end
        end
    end
    return true
end

function AutoCook.getAvailableItemsNeeded(craftRecipe, player, containerList)
    local items = ArrayList.new()
    local inputs = craftRecipe:getInputs()
    for sourceIt=0, inputs:size()-1 do
        local inputScript = inputs:get(sourceIt)
        if inputScript:getResourceType() == ResourceType.Item then
            local itemList = inputScript:getPossibleInputItems()
            local gotOne = false
            for itemIt=0, itemList:size()-1 do
                local item = itemList:get(itemIt)
                local inventoryItem = player:getInventory():getFirstTypeRecurse(item:getFullName());
                if inventoryItem then
                    if AutoCook.Verbose then print('getAvailableItemsNeeded '..tab2str(craftRecipe:getName())..' '..sourceIt..' input '..itemIt..' '..tab2str(item)..' amount='..tostring(inputScript:getAmount())) end
                    items:add(inventoryItem)
                    gotOne = true
                    break
                end
            end
            if not gotOne then return false end
        end
    end
    return items
end
