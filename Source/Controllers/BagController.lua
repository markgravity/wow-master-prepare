---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by markg.
--- DateTime: 20/06/2021 20:17
---
local BAG_PROVIDERS = MasterPrepare.BAG_PROVIDERS
local AceEvent = LibStub("AceEvent-3.0")
local MESSAGE = MasterPrepare.MESSAGE
local POINT = MasterCore.POINT
local SCRIPT_HANDLER = MasterCore.SCRIPT_HANDLER

local SHOWING_MARKERS_STATUS = {
    READY = 1,
    IN_PROGRESS = 2,
    DONE = 3
}
local BagController, super = MasterCore.Class:Create("BagController")
MasterPrepare.BagController = BagController

function BagController:Init()
    self = super.Init(self)

    self.bagProviders = self:_GetBagProviders()
    self.showingMarkersStatus = SHOWING_MARKERS_STATUS.DONE
    self.junkItems = {}
    self.markedButtons = {}
    AceEvent:RegisterMessage(MESSAGE.JUNK_ITEMS_UPDATED, function(_, items)
        self:_HideAllMarkers()
        self.junkItems = items
        self.showingMarkersStatus = SHOWING_MARKERS_STATUS.READY
    end)
    return self
end

function BagController:OnUpdate()
    if self.showingMarkersStatus == SHOWING_MARKERS_STATUS.READY then
        self:_ShowMarkers()
    end
end
function BagController:_ShowMarkers()
    self.showingMarkersStatus = SHOWING_MARKERS_STATUS.IN_PROGRESS
    for itemID, _ in pairs(self.junkItems) do
        for _, provider in ipairs(self.bagProviders) do
            local buttons = provider:GetButtons()
            if #buttons == 0 then
                self.showingMarkersStatus = SHOWING_MARKERS_STATUS.READY
                return
            end

            -- Get button by item id and show marker
            local found = false
            for _, button in ipairs(buttons) do
                if button.itemID == itemID then
                    found = true
                    self:_ShowMarker(button.frame)
                    table.insert(self.markedButtons, button.frame)
                end
            end

            -- Stop whenever an item can't find a button in bags
            if not found then
                self.showingMarkersStatus = SHOWING_MARKERS_STATUS.READY
                return
            end
        end
    end

    self.showingMarkersStatus = SHOWING_MARKERS_STATUS.DONE
end

function BagController:_ShowMarker(button)
    if not button.junkMarkerIcon then
        local icon = button:CreateTexture(nil, 'OVERLAY')
        icon:SetTexture('Interface/Buttons/UI-GroupLoot-Coin-Up')
        icon:SetPoint(POINT.BOTTOM_RIGHT, 2, -2)
        icon:SetSize(15, 15)

        button.junkMarkerIcon = icon
    end
    button.junkMarkerIcon:Show()
end

function BagController:_HideAllMarkers()
    for _, button in ipairs(self.markedButtons) do
        if button.junkMarkerIcon then
            button.junkMarkerIcon:Hide()
        end
    end
    self.markedButtons = {}
end

function BagController:_GetBagProviders()
    local providers = {}
    for _, provider in pairs(BAG_PROVIDERS) do
        if provider:IsEnabled() then
            table.insert(providers, provider)
        end
    end

    return providers
end