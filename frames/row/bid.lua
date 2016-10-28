
local myname, ns = ...


local function GetDisplayedBid(index)
	local _, _, _, _, _, _, _, min_bid, increment, buyout, bid =
		GetAuctionItemInfo("list", index)
	if bid == 0 then bid = min_bid end
	if bid == buyout then return end
	return bid
end


local function SetValue(self, index)
	if not index then return self:SetText() end
	self:SetText(ns.FormatGold(GetDisplayedBid(index)))
end


function ns.CreateAuctionBid(parent)
	local bid = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	bid.SetValue = SetValue
	return bid
end
