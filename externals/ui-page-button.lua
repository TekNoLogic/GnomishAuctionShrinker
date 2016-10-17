
local myname, ns = ...


local BUTTS = "Interface\\Buttons\\"


local function OnClick(self)
	PlaySound("igMainMenuOptionCheckBoxOn")
end


function ns.CreatePageButton(parent, type)
	assert(type == "Next" or type == "Prev", "`type` must be 'Next' or 'Prev'")

	local butt = CreateFrame("Button", nil, parent)
	butt:SetSize(32, 32)

	butt:SetNormalTexture(BUTTS.. "UI-SpellbookIcon-".. type.. "Page-Up")
	butt:SetPushedTexture(BUTTS.. "UI-SpellbookIcon-".. type.. "Page-Down")
	butt:SetDisabledTexture(BUTTS.. "UI-SpellbookIcon-".. type.. "Page-Disabled")
	butt:SetHighlightTexture(BUTTS.. "UI-Common-MouseHilight", "ADD")

	butt:HookScript("OnClick", OnClick)

	return butt
end
