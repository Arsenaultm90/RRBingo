BingoAddon = {}
BingoAddon.players = {}
BingoAddon.locked = false

-- Create the minimap button
BingoAddon.minimapButton = CreateFrame("Button", "BingoMinimapButton", Minimap)
BingoAddon.minimapButton:SetSize(32, 32)
BingoAddon.minimapButton:SetNormalTexture("Interface/Icons/INV_Misc_QuestionMark") -- Replace with your icon texture
BingoAddon.minimapButton:SetHighlightTexture("Interface/Minimap/UI-Minimap-ZoomButton-Highlight")
BingoAddon.minimapButton:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -5, -5) -- Position it near the minimap

-- Click event to show/hide the Bingo frame
BingoAddon.minimapButton:SetScript("OnClick", function()
    BingoFrame:SetShown(not BingoFrame:IsShown())
end)

-- Create a function to update the minimap icon's position
function BingoAddon:UpdateMinimapButtonPosition()
    local angle = math.rad(360) -- Adjust angle as needed
    local x = 80 * cos(angle) -- Adjust distance from center
    local y = 80 * sin(angle)
    BingoAddon.minimapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

-- Function to set minimap icon visibility
function BingoAddon:SetMinimapButtonVisibility(visible)
    if visible then
        BingoAddon.minimapButton:Show()
    else
        BingoAddon.minimapButton:Hide()
    end
end

-- Call the update function initially
BingoAddon:UpdateMinimapButtonPosition()


-- BINGO SQUARES

function BingoAddon:ToggleDropdown(square)
    if self.locked then
        return
    end

    local dropdown = CreateFrame("Frame", "BingoDropdown", square, "UIDropDownMenuTemplate")
    dropdown:SetPoint("TOPLEFT", square, "BOTTOMLEFT", 0, 0)
    UIDropDownMenu_SetWidth(dropdown, 100)

    local function OnClick(self)
        BingoAddon:SelectPlayer(square, self.value)
        CloseDropDownMenus()
    end

    -- Clear existing dropdown options
    UIDropDownMenu_Initialize(dropdown, function(self, level)
        local info
        if IsInRaid() then
            local numMembers = GetNumGroupMembers()
            for i = 1, numMembers do
                local name, _, _, _, _, _, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(i)
                if name then
                    info = UIDropDownMenu_CreateInfo()
                    info.text = name
                    info.value = name
                    info.func = OnClick
                    UIDropDownMenu_AddButton(info)
                end
            end
        else
            info = UIDropDownMenu_CreateInfo()
            info.text = "Not in a raid group"
            UIDropDownMenu_AddButton(info)
        end
    end)
end


function BingoAddon:SelectPlayer(square, playerName)
    -- Store the selected player's name in the square
    square.playerName = playerName
    -- Update the square's display (you can customize this)
    square:SetText(playerName)
end

function BingoAddon:LockChoices()
    self.locked = true
end

function BingoAddon:AnnounceWinner(winner)
    SendChatMessage(winner .. " has won Bingo!", "RAID")
end
