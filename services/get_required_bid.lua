
local myname, ns = ...


function ns.GetRequiredBid(index)
	local _, _, _, _, _, _, _, min_bid, increment, _, bid =
		GetAuctionItemInfo("list", index)

	if bid == 0 then return min_bid end
	return bid + increment
end
