
local myname, ns = ...


local all_scan
local watcher = CreateFrame("Frame")
watcher:Hide()


watcher:SetScript("OnUpdate", function(self)
	if not CanSendAuctionQuery("list") then return end
	ns.SendMessage("_AUCTION_QUERY_COMPLETE", all_scan)
	self:Hide()
end)


hooksecurefunc("QueryAuctionItems", function(_, _, _, _, _, _, get_all)
	all_scan = get_all
	ns.SendMessage("_AUCTION_QUERY_SENT", all_scan)
	watcher:Show()
end)
