
local myname, ns = ...


local count
local function Update()
	local num, total = GetNumAuctionItems("list")
	if total == 0 then return count:Hide() end

	local first = AuctionFrameBrowse.page * NUM_AUCTION_ITEMS_PER_PAGE + 1
	local last = first + num - 1

	count:SetFormattedText(NUMBER_OF_RESULTS_TEMPLATE, first, last, total)
	count:Show()
end


function ns.CreateResultsCount(parent)
	count = parent:CreateFontString(nil, nil, "GameFontHighlightSmall")

	local frame = CreateFrame("Frame", nil, parent)
	frame:SetScript("OnEvent", Update)
	frame:SetScript("OnShow", Update)
	frame:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")

	return count
end
