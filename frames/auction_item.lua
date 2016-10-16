
local myname, ns = ...


local ICON_SIZE = 18
local GAP = 4


local icons = {}
local texts = {}
local function SetValue(self, index)
	icons[self]:SetValue(index)
	texts[self]:SetValue(index)
end


function ns.CreateAuctionItem(parent)
	local item = CreateFrame("Frame", nil, parent)

	item.SetValue = SetValue

	local icon = ns.CreateAuctionIcon(item)
	icon:SetSize(ICON_SIZE, ICON_SIZE)
	icon:SetPoint("LEFT", item, GAP/2, 0)
	icons[item] = icon

	local name = ns.CreateAuctionName(item)
	name:SetPoint("LEFT", icon, "RIGHT", GAP, 0)
	name:SetPoint("TOP")
	name:SetPoint("BOTTOM")
	name:SetPoint("RIGHT")
	name:SetJustifyH("LEFT")
	texts[item] = name

	return item
end
