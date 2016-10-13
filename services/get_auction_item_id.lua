
local myname, ns = ...


function ns.GetAuctionItemID(index)
	return (select(17, GetAuctionItemInfo("list", index)))
end
