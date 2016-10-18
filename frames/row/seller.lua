
local myname, ns = ...


local function SetValue(self, index)
	if not index then return self:SetText() end

	local seller = select(14, GetAuctionItemInfo("list", index))
	self:SetText(seller)
end


function ns.CreateAuctionSeller(parent)
	local seller = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	seller.SetValue = SetValue
	return seller
end
