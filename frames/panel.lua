
local myname, ns = ...


local NUM_ROWS = 14


local function UpdateResultText()
	BrowseNoResultsText:SetShown(GetNumAuctionItems("list") == 0)
end


local function OnListUpdate()
	AuctionFrameBrowse.isSearching = nil
	BrowseNoResultsText:SetText(BROWSE_NO_RESULTS)
	UpdateResultText()
end


function ns.CreatePanel()
	local panel = CreateFrame("Frame", nil, AuctionFrameBrowse)
	panel:SetSize(605, 305)
	panel:SetPoint("TOPLEFT", 188, -103)

	local nextbutt = ns.CreateAuctionPageButton(panel, "Next")
	nextbutt:SetPoint("BOTTOMRIGHT")

	local prevbutt = ns.CreateAuctionPageButton(panel, "Prev")
	prevbutt:SetPoint("RIGHT", nextbutt, "LEFT")

	local counttext = ns.CreateResultsCount(panel)
	counttext:SetPoint("RIGHT", prevbutt, "LEFT")

	local columns = ns.CreateColumns(panel)
	ns.CreateHeader(panel, columns)

	local scrollframe = ns.CreateScrollFrame(panel, columns)
	local scrollbar = ns.CreateScrollBar(panel, scrollframe, NUM_ROWS)


	panel:EnableMouseWheel(true)
	panel:SetScript("OnMouseWheel", function(self, value)
		scrollbar:RealSetValue(scrollbar:GetValue() - value*10)
	end)

	panel:SetScript("OnShow", UpdateResultText)


	ns.RegisterCallback(panel, "AUCTION_ITEM_LIST_UPDATE", OnListUpdate)
end
