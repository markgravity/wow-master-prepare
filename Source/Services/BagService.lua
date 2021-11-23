local BAG_PROVIDERS = MasterPrepare.BAG_PROVIDERS
local Config = MasterPrepare.Config

local BagService, super = MasterCore.Class:Create("BagService")
MasterPrepare.BagService = BagService

function BagService:Init()
  self = super.Init(self)

  -- Get bag providers
  local providers = {}
  for _, provider in pairs(BAG_PROVIDERS) do
      if provider:IsEnabled() then
          table.insert(providers, provider)
      end
  end

  self.providers = providers
end

function BagService:FindSoulboundItems()
  for _, provider in ipairs(self.bagProviders) do
      local buttons = provider:GetButtons()
      for _, button in ipairs(buttons) do
      end
  end
end
