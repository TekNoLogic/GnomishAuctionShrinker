
local myname, ns = ...


local NUM_ROWS, BOTTOM_GAP = 14, 25
local ROW_HEIGHT = math.floor((305-BOTTOM_GAP)/NUM_ROWS)
local TEXT_GAP = 4
local noop = function() end


---------------------
--      Panel      --
---------------------

local panel = CreateFrame("Frame", nil, AuctionFrameBrowse)
panel:SetWidth(605) panel:SetHeight(305)
panel:SetPoint("TOPLEFT", 188, -103)

local nextbutt = ns.CreateAuctionPageButton(panel, "Next")
nextbutt:SetPoint("BOTTOMRIGHT")

local prevbutt = ns.CreateAuctionPageButton(panel, "Prev")
prevbutt:SetPoint("RIGHT", nextbutt, "LEFT")

local counttext = ns.CreateResultsCount(panel)
counttext:SetPoint("RIGHT", prevbutt, "LEFT")

local columns = ns.CreateColumns(panel)

local rows = {}
for i=1,NUM_ROWS do
	local row = ns.CreateAuctionRow(panel, columns)
	row:SetHeight(ROW_HEIGHT)
	row:SetPoint("LEFT")
	row:SetPoint("RIGHT")
	if i == 1 then row:SetPoint("TOP")
	else row:SetPoint("TOP", rows[i-1], "BOTTOM") end
	rows[i] = row
end

ns.CreateHeader(panel, columns)


local scrollbar, upbutt, downbutt = BrowseScrollFrameScrollBar, BrowseScrollFrameScrollBarScrollUpButton, BrowseScrollFrameScrollBarScrollDownButton
scrollbar.RealSetValue, scrollbar.RealSetMinMaxValues, scrollbar.RealSetValueStep = scrollbar.SetValue, scrollbar.SetMinMaxValues, scrollbar.SetValueStep
scrollbar.SetValue, scrollbar.SetMinMaxValues, scrollbar.SetValueStep = noop, noop, noop

local function OnMouseWheel(self, value) scrollbar:RealSetValue(scrollbar:GetValue() - value*10) end


-----------------------
--      Updater      --
-----------------------

local orig = QueryAuctionItems
function QueryAuctionItems(...)
	scrollbar:RealSetValue(0)
	return orig(...)
end


local offset = 0
function ns.Update()
	local selected = GetSelectedAuctionItem("list")
	AuctionFrame.buyoutPrice = nil

	local numBatchAuctions, totalAuctions = GetNumAuctionItems("list")

	BrowseNoResultsText:SetShown(numBatchAuctions == 0)

	local sorted = ns.GetSortedResults()
	for i,row in ipairs(rows) do
		local index = sorted and sorted[offset + i] or (offset + i)
		row:SetValue(index)
	end

	if totalAuctions > 0 then
		if numBatchAuctions-NUM_ROWS <= 0 then
			scrollbar:Disable()
			upbutt:Disable()
			downbutt:Disable()
		else
			scrollbar:Enable()
			scrollbar:RealSetMinMaxValues(0, numBatchAuctions-NUM_ROWS)
			scrollbar:RealSetValueStep(1)
		end
	end
end


panel:SetScript("OnEvent", function()
	ns.MarkSortDirty()
	AuctionFrameBrowse.isSearching = nil
	BrowseNoResultsText:SetText(BROWSE_NO_RESULTS)
	ns.Update()
end)
panel:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")


panel:SetScript("OnShow", ns.Update)


ns.RegisterCallback(panel, "AUCTION_QUERY_SENT", function(self, message, all_scan)
	if all_scan then
		self:UnregisterEvent("AUCTION_ITEM_LIST_UPDATE")
	else
		self:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
	end
end)


-------------------------
--      Scrolling      --
-------------------------

panel:SetScript("OnMouseWheel", OnMouseWheel)
panel:EnableMouseWheel(true)
scrollbar:SetScript("OnValueChanged", function(self, value, ...)
	offset = value
	local min, max = self:GetMinMaxValues()
	if value == min then upbutt:Disable() else upbutt:Enable() end
	if value == max then downbutt:Disable() else downbutt:Enable() end
	ns.Update()
end)
upbutt:SetScript("OnClick", function() scrollbar:RealSetValue(scrollbar:GetValue() - 10); PlaySound("UChatScrollButton") end)
downbutt:SetScript("OnClick", function() scrollbar:RealSetValue(scrollbar:GetValue() + 10); PlaySound("UChatScrollButton") end)
