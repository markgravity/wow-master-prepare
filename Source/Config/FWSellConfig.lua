---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by markg.
--- DateTime: 18/06/2021 21:22
---
local L = LibStub("AceLocale-3.0"):GetLocale(MASTER_PREPARE_NAME)
local FW_TYPE = MasterPrepare.FW_TYPE

local FWSellConfig, super = MasterCore.Class:Create("FWSellConfig", MasterCore.Config)
MasterPrepare.FWSellConfig = FWSellConfig
function FWSellConfig:Init(type, db, order)
    self = super.Init(self, db, order)
    self.type = type
    self.name = "Sell"
    return self
end

function FWSellConfig:GetOptions()
    local itemName
    if self.type == FW_TYPE.FOOD then
        itemName = "food"
    end

    if self.type == FW_TYPE.WATER then
        itemName = "water"
    end

    return {
        name = self.name,
        type = 'group',
        handler = self,
        order = self.order,
        args = {
            enable = {
                order = self:_AutoIncrementOrder(true),
                type = "toggle",
                name = "Sell junk " .. itemName .. " automatically",
                width = "full",
                set = "Set",
                get = "GetEnable"
            },
            space1 = {
                order = self:_AutoIncrementOrder(),
                type = "description",
                name = "\n\n",
                width = "full"
            },
            header = {
                order = self:_AutoIncrementOrder(),
                type = "header",
                name = "Criteria",
            },
            info = {
                order = self:_AutoIncrementOrder(),
                type = "description",
                name = "The criteria to find junk foods",
                width = "full"
            },
            lowValue = {
                order = self:_AutoIncrementOrder(),
                type = "toggle",
                name = "Low value",
                desc = "The " .. itemName .. " has restore value lower than the most suitable " .. itemName,
                set = "SetCriteria",
                get = "GetCriteriaLowValue",
                disabled = function()
                    return not self:GetEnable()
                end
            },
            lowStack = {
                order = self:_AutoIncrementOrder(),
                type = "toggle",
                name = "Low stack",
                desc = "The un-full stack most suitable "..itemName.." which can't buy from current vendor",
                set = "SetCriteria",
                get = "GetCriteriaLowStack",
                disabled = function()
                    return not self:GetEnable()
                end
            },
        }
    }
end

function FWSellConfig:GetEnable()
    return self:Get("enable")
end

function FWSellConfig:SetCriteria(info, value)
    self:Set(info, value, self.db.criteria)
end

function FWSellConfig:GetCriteria(info)
    local key = self:_GetKey(info)
    return self.db.criteria[key]
end

function FWSellConfig:GetCriteriaLowValue()
    return self:GetCriteria("lowValue")
end

function FWSellConfig:GetCriteriaLowStack()
    return self:GetCriteria("lowStack")
end

function FWSellConfig:GetDefaults()
    return {
        enable = true,
        criteria = {
            lowValue = true,
            lowStack = false,
        }
    }
end

