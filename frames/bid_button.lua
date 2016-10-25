
local myname, ns = ...


local butt = BrowseBidButton


ns.RegisterCallback(butt, "_DIALOG_SHOWN", function(self)
	self:Disable()
end)


local function CanBid(index)
	local bid = ns.GetRequiredBid(index)
	if bid > MAXIMUM_BID_PRICE then return false end

	local _, _, _, _, _, _, _, _, _, _, _, is_high_bidder, _, seller =
		GetAuctionItemInfo("list", index)
	if is_high_bidder then return false end
	if seller == UnitName("player") then return false end
	if GetMoney() < bid then return false end

	return true
end


ns.RegisterCallback(butt, "_SELECTION_CHANGED", function(self, message, index)
	if not index then return self:Disable() end

	if CanBid(index) then
		MoneyInputFrame_SetCopper(BrowseBidPrice, ns.GetRequiredBid(index))
		self:Enable()
	else
		self:Disable()
	end
end)
