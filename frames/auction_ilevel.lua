
local myname, ns = ...


local function SetValue(self, index)
	if not index then return self:SetText() end

	local item_id = ns.GetAuctionItemID(index)
	local _, _, _, ilevel = GetItemInfo(item_id)

	self:SetText(ilevel)
end


function ns.CreateAuctionIlevel(parent)
	local ilvl = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	ilvl.SetValue = SetValue
	return ilvl
end
