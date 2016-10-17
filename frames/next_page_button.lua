
local myname, ns = ...


local function OnClick(self)
	AuctionFrameBrowse.page = AuctionFrameBrowse.page + 1
	AuctionFrameBrowse_Search()
end


local function OnEvent(self, event)
	local num, total = GetNumAuctionItems("list")
	self:SetShown(total > 0 and num < total)
end


local function OnQueryComplete(self)
	local num, total = GetNumAuctionItems("list")
	local last_page = math.ceil(total/NUM_AUCTION_ITEMS_PER_PAGE) - 1

	if total > 0 and num < total then
		if total > NUM_AUCTION_ITEMS_PER_PAGE then
			self:SetEnabled(AuctionFrameBrowse.page ~= last_page)
		else
			self:Disable()
		end
	end
end


function ns.CreateNextPageButton(parent)
	local butt = ns.CreatePageButton(parent, "Next")
	butt:SetSize(24, 24)

	butt:SetScript("OnClick", OnClick)
	butt:SetScript("OnEvent", OnEvent)

	butt:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
	ns.MixinPendingQuery(butt)

	butt.OnQuerySent = butt.Disable
	butt.OnQueryComplete = OnQueryComplete

	return butt
end
