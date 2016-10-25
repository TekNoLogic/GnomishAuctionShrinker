
local myname, ns = ...


local count
local function Update()
	local num, total = GetNumAuctionItems("list")
	if total == 0 then return count:Hide() end
	if num > NUM_AUCTION_ITEMS_PER_PAGE then return count:Hide() end

	local first = AuctionFrameBrowse.page * NUM_AUCTION_ITEMS_PER_PAGE + 1
	local last = first + num - 1

	count:SetFormattedText(NUMBER_OF_RESULTS_TEMPLATE, first, last, total)
	count:Show()
end


local function OnQuerySent(self, message, all_scan)
	if all_scan then count:Hide() end
end


function ns.CreateResultsCount(parent)
	count = parent:CreateFontString(nil, nil, "GameFontHighlightSmall")

	local frame = CreateFrame("Frame", nil, parent)
	frame:SetScript("OnShow", Update)

	ns.RegisterCallback(count, "_AUCTION_ITEM_LIST_UPDATE", Update)
	ns.RegisterCallback(count, "_AUCTION_QUERY_SENT", OnQuerySent)

	return count
end
