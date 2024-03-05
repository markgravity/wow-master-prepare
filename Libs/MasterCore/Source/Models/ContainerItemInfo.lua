---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by markg.
--- DateTime: 16/06/2021 00:25
---

local ContainerItemInfo, super = MasterCore.Class:Create("ContainerItemInfo")
MasterCore.ContainerItemInfo = ContainerItemInfo

function ContainerItemInfo:Init(bagID, slot)
    self = super.Init(self)
    self.texture, self.itemCount, self.locked, self.quality, self.readable, self.lootable, self.itemLink = GetContainerItemInfo(bagID, slot);

    if self.texture == nil then return self end

    if self.itemCount then
        return self
    else
        self.texture.itemLink = self.texture.hyperlink
        self.texture.itemCount = self.texture.stackCount
        return self.texture
    end
end