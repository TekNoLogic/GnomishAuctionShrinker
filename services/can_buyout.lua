
local myname, ns = ...


function ns.CanBuyout(index)
	local buyout = ns.GetBuyout(index)
	if buyout == 0 then return false end
	if GetMoney() < buyout then return false end

	local bid = ns.GetRequiredBid(index)
	if bid > buyout then return false end

	local _, _, _, _, _, _, _, _, _, _, high_bid, is_high_bidder =
		GetAuctionItemInfo("list", index)
	if is_high_bidder and (GetMoney() + high_bid) < buyout then return false end

	return true
end
