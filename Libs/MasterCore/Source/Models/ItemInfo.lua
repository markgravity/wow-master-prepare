---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by markg.
--- DateTime: 15/06/2021 23:23
---
local ItemInfo, super = MasterCore.Class:Create("ItemInfo")
MasterCore.ItemInfo = ItemInfo

function ItemInfo:Init(id)
    if id == nil then
        return nil
    end

    self = super.Init(self)
    self.name, self.link, self.rarity, self.level, self.minLevel, self.type,
    self.subtype, self.stackCount, self.equipLoc, self.texture, self.sellPrice = GetItemInfo(id)

    return self
end