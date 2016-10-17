
local myname, ns = ...


local types = {}
local function OnClick(self)
	local val = 1
	if types[self] == "Prev" then val = -1 end
	AuctionFrameBrowse.page = AuctionFrameBrowse.page + val
	AuctionFrameBrowse_Search()
end


local function OnEvent(self, event)
	local num, total = GetNumAuctionItems("list")
	self:SetShown(total > 0 and num < total)
end


local function OnQuerySent(self)
	self:Disable()
end


local function OnQueryComplete(self)
	local num, total = GetNumAuctionItems("list")
	if total == 0 or num == total then return end
	if total <= NUM_AUCTION_ITEMS_PER_PAGE then return self:Disable() end

	local test_value = 0
	if types[self] == "Next" then
		test_value =  math.ceil(total/NUM_AUCTION_ITEMS_PER_PAGE) - 1
	end
	self:SetEnabled(AuctionFrameBrowse.page ~= test_value)
end


function ns.CreateAuctionPageButton(parent, type)
	local butt = ns.CreatePageButton(parent, type)
	types[butt] = type

	butt:SetSize(24, 24)

	butt:SetScript("OnClick", OnClick)
	butt:SetScript("OnEvent", OnEvent)

	butt:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
	ns.MixinPendingQuery(butt)

	butt.OnQuerySent = OnQuerySent
	butt.OnQueryComplete = OnQueryComplete

	return butt
end
