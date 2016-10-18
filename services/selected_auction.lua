
local myname, ns = ...


local selected


function ns.GetSelectedAuction()
	return selected
end


hooksecurefunc("SetSelectedAuctionItem", function(type, index)
	if type ~= "list" then return end
	selected = index
	ns.SendMessage("SELECTION_CHANGED", index)
end)


local function ClearSelection()
	selected = nil
	ns.SendMessage("SELECTION_CHANGED", nil)
end


ns.RegisterCallback({}, "AUCTION_QUERY_SENT", ClearSelection)
hooksecurefunc("PlaceAuctionBid", ClearSelection)
