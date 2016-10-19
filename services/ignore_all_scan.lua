
local myname, ns = ...


-- A simple event handler that forwards AUCTION_ITEM_LIST_UPDATE events on as
-- messages, but won't forward the ones that occur during an all-scan.
local listener = CreateFrame("Frame")
listener:SetScript("OnEvent", function(self, event, ...)
	ns.SendMessage(event, ...)
end)
listener:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")


ns.RegisterCallback(listener, "AUCTION_QUERY_SENT", function(self, message, all_scan)
	if all_scan then
		self:UnregisterEvent("AUCTION_ITEM_LIST_UPDATE")
	else
		self:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
	end
end)
