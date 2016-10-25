
local myname, ns = ...


local butt = BrowseBuyoutButton


ns.RegisterCallback(butt, "_DIALOG_SHOWN", function(self)
	self:Disable()
end)


ns.RegisterCallback(butt, "_AUCTION_QUERY_SENT", function()
	AuctionFrame.buyoutPrice = nil
end)


ns.RegisterCallback(butt, "_SELECTION_CHANGED", function(self, message, index)
	if not index then return self:Disable() end

	if ns.CanBuyout(index) then
		self:Enable()
		AuctionFrame.buyoutPrice = ns.GetBuyout(index)
	else
		self:Disable()
	end
end)
