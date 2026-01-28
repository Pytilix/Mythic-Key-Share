--[[
    ============================================================================
    FPS & MS Monitor
    Copyright (c) 2021-2026 Pytilix
    All rights reserved.

    This Add-on and its source code are proprietary. 
    Unauthorized copying, modification, or distribution of this file, 
    via any medium, is strictly prohibited.
    
    The source code is provided for personal use and educational purposes 
    only, as per Blizzard's UI Add-On Development Policy.
    ============================================================================
--]]

local frame = CreateFrame("Frame")

-- Events registrieren
frame:RegisterEvent("CHAT_MSG_PARTY")
frame:RegisterEvent("CHAT_MSG_PARTY_LEADER")
frame:RegisterEvent("CHAT_MSG_RAID")
frame:RegisterEvent("CHAT_MSG_RAID_LEADER")
frame:RegisterEvent("CHAT_MSG_INSTANCE_CHAT")

-- Funktion zum Finden des Keys im Inventar
local function GetKeystoneLink()
    for bag = 0, 4 do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local itemID = C_Container.GetContainerItemID(bag, slot)
            if itemID == 180653 then -- Mythic Keystone Item ID
                return C_Container.GetContainerItemLink(bag, slot)
            end
        end
    end
    return nil
end

-- Funktion zum Posten
local function ShareMythicKey()
    local keyLink = GetKeystoneLink()
    
    if keyLink then
        local channel = "PARTY"
        if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
            channel = "INSTANCE_CHAT"
        elseif IsInRaid() then
            channel = "RAID"
        end
        
        -- Englischer Text
        SendChatMessage("My Key: " .. keyLink, channel)
    end
end

-- Event-Handler
frame:SetScript("OnEvent", function(self, event, text)
    if text:lower() == "!key" then
        -- Small random delay to prevent spam protection kicks
        C_Timer.After(math.random(0.1, 0.4), function()
            ShareMythicKey()
        end)
    end
end)

-- Load Message in English
print("|cff00ff00Mythic+ Key Sharer loaded!|r Type !key in party chat.")