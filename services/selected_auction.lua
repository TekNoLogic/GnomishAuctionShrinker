
local myname, ns = ...


hooksecurefunc("SetSelectedAuctionItem", function(type, index)
	if type ~= "list" then return end
	ns.SendMessage("SELECTION_CHANGED", index)
end)


ns.RegisterCallback({}, "AUCTION_QUERY_SENT", function()
	ns.SendMessage("SELECTION_CHANGED", nil)
end)


hooksecurefunc("PlaceAuctionBid", function()
	ns.SendMessage("SELECTION_CHANGED", nil)
end)
