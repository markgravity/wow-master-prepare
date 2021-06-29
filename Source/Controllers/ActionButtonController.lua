---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by markg.
--- DateTime: 21/06/2021 22:20
---
local EVENT = MasterCore.EVENT.BAG_UPDATE
local ContainerItemInfo = MasterCore.ContainerItemInfo
local Config = MasterPrepare.Config
local FW_TYPE = MasterPrepare.FW_TYPE
local MESSAGE = MasterPrepare.MESSAGE

local ActionButtonController, super = MasterCore.Class:Create("ActionButtonController", MasterCore.EventController)
MasterPrepare.ActionButtonController = ActionButtonController

function ActionButtonController:Init(type)
    self = super.Init(self, {
        EVENT.BAG_UPDATE
    })

    self.type = type
    return self
end

function ActionButtonController:OnMessage(message, food, water)
    if message == MESSAGE.PREPRATION_CHECKED then
        if self.type == FW_TYPE.FOOD then
            self.prepration = food
            self.config = Config.food.actionButton
        end

        if self.type == FW_TYPE.WATER then
            self.prepration = water
            self.config = Config.water.actionButton
        end

        self:_Check()
    end
end
function ActionButtonController:_Check()
    local key = self.config:GetKey()
    local actionSlot = GetActionSlot(key)
    local _, itemID = GetActionInfo(actionSlot)

    if self.actionItem == nil then
        self.actionItem = self.prepration:FindItemToUse()

        if self.actionItem then
            self:_Swap(self.actionItem, actionSlot)
        end
        return
    end

    -- Re-swap when action item was removed from this slot
    if itemID ~= self.actionItem.id then
        self:_Swap(self.actionItem, actionSlot)
    end

    -- Stop when action item still in stock
    local containerItemInfo = ContainerItemInfo:Init(self.actionItem.bag, self.actionItem.slot)
    if containerItemInfo.itemCount ~= nil and containerItemInfo.itemCount > 0 then
        return
    end

    -- Find a new one when the previous is out of stock
    self.actionItem = self.prepration:FindItemToUse()

    --print("Swap")
    self:_Swap(self.actionItem, actionSlot)
end

function ActionButtonController:_Swap(item, actionSlot)
    PickupContainerItem(item.bag, item.slot)
    PlaceAction(actionSlot)
    PutItemInBackpack()
end
