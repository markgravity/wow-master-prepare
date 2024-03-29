---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by markg.
--- DateTime: 16/06/2021 10:30
---
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceEvent = LibStub("AceEvent-3.0")
local MESSAGE = MasterPrepare.MESSAGE
local L = LibStub("AceLocale-3.0"):GetLocale(MASTER_PREPARE_NAME)
local FWConfig = MasterPrepare.FWConfig
local FW_TYPE = MasterPrepare.FW_TYPE
local GearConfig = MasterPrepare.GearConfig
local PotionConfig = MasterPrepare.PotionConfig

local Config = {}
MasterPrepare.Config = Config

function Config:Setup()
    self.db = LibStub("AceDB-3.0"):New("MasterPrepareConfig", self:GetDeaults())

    self.food = FWConfig:Init(FW_TYPE.FOOD, self.db.char, 1)
    self.water = FWConfig:Init(FW_TYPE.WATER, self.db.char, 2)
    self.gear = GearConfig:Init(self.db.char.gear, 3)
    self.potion = PotionConfig:Init(self.db.char.potion, 4)

    -- Register config
    AceConfig:RegisterOptionsTable(MASTER_PREPARE_NAME, self:GetOptions())
    AceConfigDialog:AddToBlizOptions(MASTER_PREPARE_NAME)
    AceConfigDialog:AddToBlizOptions(MASTER_PREPARE_NAME, L["Food"], MASTER_PREPARE_NAME, "food")
    AceConfigDialog:AddToBlizOptions(MASTER_PREPARE_NAME, L["Water"], MASTER_PREPARE_NAME, "water")
    AceConfigDialog:AddToBlizOptions(MASTER_PREPARE_NAME, L["Gear"], MASTER_PREPARE_NAME, "gear")
    AceConfigDialog:SetDefaultSize(MASTER_PREPARE_NAME, 600, 500)

    -- Register cmd to open config dialog
    MasterPrepareAddon:RegisterChatCommand(MASTER_PREPARE_CMD, function()
        AceConfigDialog:Open(MASTER_PREPARE_NAME)
    end)
end

function Config:GetOptions()
    return {
        name = MASTER_PREPARE_NAME,
        handler = self,
        type = "group",
        childGroups = "tab",
        args = {
            food = self.food:GetOptions(),
            water = self.water:GetOptions(),
            gear = self.gear:GetOptions(),
            potion = self.potion:GetOptions()
        },
    }
end

function Config:GetDeaults()
    return {
       char = {
           food = FWConfig:GetDefaults(),
           water = FWConfig:GetDefaults(),
           gear = GearConfig:GetDefaults(),
           potion = PotionConfig:GetDefaults()
       }
    }
end