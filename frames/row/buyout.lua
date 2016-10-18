
local myname, ns = ...


local function SetValue(self, index)
	if not index then return self:SetText() end

	local buyout = ns.GetBuyout(index)
	self:SetText(buyout > 0 and ns.GS(buyout) or "----")
end


function ns.CreateAuctionBuyout(parent)
	local buyout = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	buyout.SetValue = SetValue
	return buyout
end
