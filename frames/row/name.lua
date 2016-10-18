
local myname, ns = ...


local function SetValue(self, index)
	if not index then return self:SetText() end

	local name, _, _, quality = GetAuctionItemInfo("list", index)
	local color = ns.item_colors[quality] or ns.item_colors[1]

	self:SetText(name)
	self:SetVertexColor(color.r, color.g, color.b)
end


function ns.CreateAuctionName(parent)
	local name = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	name.SetValue = SetValue
	return name
end
