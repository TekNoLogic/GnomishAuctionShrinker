
-- A simple event handler that forwards AUCTION_ITEM_LIST_UPDATE events on as
-- messages, but won't forward the ones that occur during an all-scan.


local myname, ns = ...


local function OnAuctionItemListUpdate(self, event, ...)
	ns.SendMessage("_AUCTION_ITEM_LIST_UPDATE", ...)
end


local function OnAuctionQuerySent(self, message, all_scan)
	if all_scan then
		ns.UnregisterCallback(self, "AUCTION_ITEM_LIST_UPDATE")
	else
		ns.RegisterCallback(self, "AUCTION_ITEM_LIST_UPDATE", OnAuctionItemListUpdate)
	end
end


local C = {}
ns.RegisterCallback(C, "AUCTION_ITEM_LIST_UPDATE", OnAuctionItemListUpdate)
ns.RegisterCallback(C, "_AUCTION_QUERY_SENT", OnAuctionQuerySent)
