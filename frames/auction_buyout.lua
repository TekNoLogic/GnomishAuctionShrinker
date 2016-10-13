
local myname, ns = ...


local function SetValue(self, index)
	if not index then return self:SetText() end

	local _, _, _, _, _, _, _, _, _, buyout = GetAuctionItemInfo("list", index)

	-- Lie about our buyout price if bid is huge
	local required_bid = ns.GetRequiredBid(index)
	if required_bid >= MAXIMUM_BID_PRICE then buyout = required_bid end

	self:SetText(buyout > 0 and ns.GS(buyout) or "----")
end


function ns.CreateAuctionBuyout(parent)
	local buyout = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	buyout.SetValue = SetValue
	return buyout
end
