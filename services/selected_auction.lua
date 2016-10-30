
local myname, ns = ...


local selected


function ns.GetSelectedAuction()
	return selected
end


hooksecurefunc("SetSelectedAuctionItem", function(type, index)
	if type ~= "list" then return end
	selected = index
	ns.SendMessage("_SELECTION_CHANGED", index)
end)


local function ClearSelection()
	selected = nil
	ns.SendMessage("_SELECTION_CHANGED", nil)
end


ns.RegisterCallback("_AUCTION_QUERY_SENT", ClearSelection)
hooksecurefunc("PlaceAuctionBid", ClearSelection)
