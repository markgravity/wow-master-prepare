---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by markg.
--- DateTime: 19/06/2021 09:29
---

local Dialog = {}
MasterCore.Dialog = Dialog
function Dialog:Confirm(message, onAccept, onCancel, yesText, noText)
    StaticPopupDialogs["CONFIRM_DIALOG"] = {
        text = message,
        button1 = yesText or "Yes",
        button2 = noText or "No",
        OnAccept = function()
            if onAccept then
                onAccept()
            end
        end,
        OnCancel = function()
            if onCancel then
                onCancel()
            end
        end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3, -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
    }

    StaticPopup_Show("CONFIRM_DIALOG")
end