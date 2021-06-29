---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by markg.
--- DateTime: 18/06/2021 21:22
---
local L = LibStub("AceLocale-3.0"):GetLocale(MASTER_PREPARE_NAME)
local FW_TYPE = MasterPrepare.FW_TYPE

local PREFER_CONJURE_TYPE = {
    IGNORE = "ignore",
    ALWAYS = "always",
    BETTER = "better"
}
MasterPrepare.PREFER_CONJURE_TYPE = PREFER_CONJURE_TYPE

local FWActionButtonConfig, super = MasterCore.Class:Create("FWActionButtonConfig", MasterCore.Config)
MasterPrepare.FWActionButtonConfig = FWActionButtonConfig
function FWActionButtonConfig:Init(type, db, order)
    self = super.Init(self, db, order)
    self.type = type
    self.name = "Action Button"
    return self
end

function FWActionButtonConfig:GetOptions()
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
                name = "Put the " .. itemName .. " to selected Action Button automatically",
                width = "full",
                set = "Set",
                get = "GetEnable"
            },
            key = {
                order = self:_AutoIncrementOrder(),
                type = "keybinding",
                name = "Action Button",
                desc = "The action button will be put the " .. itemName,
                validate = function(_, value)
                    if GetActionSlot(value) == nil then
                        return "This key isn't bound to any Action Button yet!"
                    end

                    return true
                end,
                set = "Set",
                get = "GetKey",
                disabled = function()
                    return not self:GetEnable()
                end
            },
            preferConjure = {
                order = self:_AutoIncrementOrder(),
                type = "select",
                values = {
                    [PREFER_CONJURE_TYPE.IGNORE] = "Ignore",
                    [PREFER_CONJURE_TYPE.ALWAYS] = "Always",
                    [PREFER_CONJURE_TYPE.BETTER] = "When it's better or equal"
                },
                name = "Prefer conjure",
                desc = "Put confure " .. itemName .. " when it's available in this character's bags",
                set = "Set",
                get = "GetPreferConjure",
                disabled = function()
                    return not self:GetEnable()
                end
            }
        }
    }
end

function FWActionButtonConfig:GetEnable()
    return self:Get("enable")
end

function FWActionButtonConfig:GetKey()
    return self:Get("key")
end

function FWActionButtonConfig:GetPreferConjure()
    return self:Get("preferConjure")
end

function FWActionButtonConfig:GetDefaults()
    return {
        enable = true,
        key = nil,
        preferConjure = PREFER_CONJURE_TYPE.IGNORE
    }
end
