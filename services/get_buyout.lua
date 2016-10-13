
local myname, ns = ...


function ns.GetBuyout(index)
	local _, _, _, _, _, _, _, _, _, buyout = GetAuctionItemInfo("list", index)

	-- Lie about our buyout price if bid is huge
	local required_bid = ns.GetRequiredBid(index)
	if required_bid >= MAXIMUM_BID_PRICE then return required_bid end

	return buyout
end
