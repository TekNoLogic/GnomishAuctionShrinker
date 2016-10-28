
local myname, ns = ...


local function SetValue(self, index)
	if not index then return self:SetText() end

	local buyout = ns.GetBuyout(index)
	self:SetText(ns.FormatGold(buyout))
end


function ns.CreateAuctionBuyout(parent)
	local buyout = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	buyout.SetValue = SetValue
	return buyout
end
