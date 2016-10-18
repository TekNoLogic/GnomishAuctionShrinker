
local myname, ns = ...


local butt = BrowseBuyoutButton


ns.RegisterCallback(butt, "DIALOG_SHOWN", function(self)
	self:Disable()
end)


ns.RegisterCallback(butt, "SELECTION_CHANGED", function(self, message, index)
	if not index then return self:Disable() end

	if ns.CanBuyout(index) then
		self:Enable()
		AuctionFrame.buyoutPrice = ns.GetBuyout(index)
	else
		self:Disable()
	end
end)
