---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by markg.
--- DateTime: 16/06/2021 11:03
---

--- Returns a ID from item link.
--- @param itemLink string @ The link of the item
--- @return string @ ID
function GetItemID(itemLink)
    if not itemLink then
        return nil
    end
    
    return tonumber(select(3, strfind(itemLink, "item:(%d+)")))
end

--- Massive buys the specified item.
--- @param index number @ The index of the item in the merchant's inventory
--- @param quantity number @ Quantity to buy.
--- @return void
function MassiveBuyMerchantItem(index, quantity)
    if quantity <= 0 then
        return
    end

    local maxStack = GetMerchantItemMaxStack(index)
    if quantity <= maxStack then
        BuyMerchantItem(index, quantity)
        return
    end

    local mod = math.fmod(quantity, maxStack)
    if mod > 0 then
        BuyMerchantItem(index, mod)
    end

    local times = math.floor(quantity / maxStack)
    for i = 1, times do
        BuyMerchantItem(index, maxStack)
    end
end

--- Sell an item in bag to opened merchant
--- @param bag number @ The bag id, where the item to use is located
--- @param slot number @ The slot in the bag, where the item to use is located
--- @return void
function SellContainerItemToMerchant(bag, slot)
    --ShowMerchantSellCursor(1)
    UseContainerItem(bag, slot)
end

--- Returns hex color code for an item quality.
--- @param number number @ The numeric ID of the quality from 0 (Poor) to 7 (Heirloom).
--- @return string
function GetItemQualityHexColor(number)
    local _, _, _, hex = GetItemQualityColor(number)
    return hex
end

--- Returns action slot by key which binded to this.
--- @param key string @ The name of the key (eg. "BUTTON1", "1", "CTRL-G")
--- @return number
function GetActionSlot(key)
    local command = GetBindingAction(key)

    -- Main Action Button Bar
    if command:find("^ActionButton") then
        local _, slot = command:match("(%a+)(%d+)")
        return tonumber(slot)
    end

    local beginMap = { 60, 49, 24, 36 }
    local pattern = "MULTIACTIONBAR(%d+)BUTTON(%d+)"
    local index, slot = command:match(pattern)
    index = tonumber(index)
    slot = tonumber(slot)

    if index and slot then
        return beginMap[index] + slot
    end

    return nil
end

local waitTable = {};
local waitFrame;

--- Call this function to wait a specified amount of time before running another function with the given parameters.
--- This function is useful when you rely on system messages to trigger your code as (especially with Guild related system messages)
--- the system message is dispatched by the server sometimes before the results have been updated.
--- Waiting to perform the next step of your code becomes easy with this function.
--- [https://wowwiki-archive.fandom.com/wiki/USERAPI_wait]
--- @param delay number @ The amount of time to wait (in seconds) before the provided function is triggered
--- @param func function @ The function to run once the wait delay is over.
--- @return boolean @ true if it succeded in adding the wait to the wait table, If the first parameter is not a number, or the seconds parameter is not a function, any call to wait will automatically fail with a result of false.
function Wait(delay, func, ...)
    if (type(delay) ~= "number" or type(func) ~= "function") then
        return false;
    end
    if (waitFrame == nil) then
        waitFrame = CreateFrame("Frame", "WaitFrame", UIParent);
        waitFrame:SetScript("onUpdate", function(self, elapse)
            local count = #waitTable;
            local i = 1;
            while (i <= count) do
                local waitRecord = tremove(waitTable, i);
                local d = tremove(waitRecord, 1);
                local f = tremove(waitRecord, 1);
                local p = tremove(waitRecord, 1);
                if (d > elapse) then
                    tinsert(waitTable, i, { d - elapse, f, p });
                    i = i + 1;
                else
                    count = count - 1;
                    f(unpack(p));
                end
            end
        end);
    end
    tinsert(waitTable, { delay, func, { ... } });
    return true;
end

if not GetContainerNumSlots then
    function GetContainerNumSlots(containerIndex)
        return C_Container.GetContainerNumSlots(containerIndex);
    end

    function GetContainerItemID(containerIndex, slotIndex)
        return C_Container.GetContainerItemID(containerIndex, slotIndex);
    end

    function GetContainerItemDurability(containerIndex, slotIndex)
        return C_Container.GetContainerItemDurability(containerIndex, slotIndex);
    end

    function GetContainerItemInfo(containerIndex, slotIndex)
        return C_Container.GetContainerItemInfo(containerIndex, slotIndex);
    end

    function GetContainerItemLink(containerIndex, slotIndex)
        return C_Container.GetContainerItemLink(containerIndex, slotIndex);
    end

    function PickupContainerItem(containerIndex, slotIndex)
        return C_Container.PickupContainerItem(containerIndex, slotIndex);
    end
end