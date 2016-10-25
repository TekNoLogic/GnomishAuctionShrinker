
local myname, ns = ...


local types = {}
local function OnClick(self)
	local val = 1
	if types[self] == "Prev" then val = -1 end
	AuctionFrameBrowse.page = AuctionFrameBrowse.page + val
	AuctionFrameBrowse_Search()
end


local function Update(self)
	local num, total = GetNumAuctionItems("list")
	if num > NUM_AUCTION_ITEMS_PER_PAGE then return self:Hide() end
	if total == 0 then return self:Hide() end
	self:Show()
end


local function OnQuerySent(self, message, all_scan)
	if all_scan then
		self:Hide()
	else
		self:Disable()
	end
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
	butt:SetScript("OnShow", Update)

	ns.RegisterCallback(butt, "_AUCTION_ITEM_LIST_UPDATE", Update)
	ns.RegisterCallback(butt, "_AUCTION_QUERY_SENT", OnQuerySent)
	ns.RegisterCallback(butt, "_AUCTION_QUERY_COMPLETE", OnQueryComplete)

	return butt
end
