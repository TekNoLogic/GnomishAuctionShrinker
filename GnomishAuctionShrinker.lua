
local myname, ns = ...

local BUYOUT_LIMIT = 800 * 100 * 100 -- 800g
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


local bidbutt = BrowseBidButton

local scrollbar, upbutt, downbutt = BrowseScrollFrameScrollBar, BrowseScrollFrameScrollBarScrollUpButton, BrowseScrollFrameScrollBarScrollDownButton
scrollbar.RealSetValue, scrollbar.RealSetMinMaxValues, scrollbar.RealSetValueStep = scrollbar.SetValue, scrollbar.SetMinMaxValues, scrollbar.SetValueStep
scrollbar.SetValue, scrollbar.SetMinMaxValues, scrollbar.SetValueStep = noop, noop, noop

local function OnMouseWheel(self, value) scrollbar:RealSetValue(scrollbar:GetValue() - value*10) end


-----------------------
--      Updater      --
-----------------------

ns.sortbyunit = true
ns.sortbyilvl = false
ns.sorttable = {}
local orig, wipe = QueryAuctionItems, wipe
function QueryAuctionItems(...)
	if select(10, ...) then ns.sortbyunit, ns.sortbyilvl = false, false end
	wipe(ns.sorttable)
	scrollbar:RealSetValue(0)
	return orig(...)
end

local function UnitSort(a,b)
	local _, _, counta, _, _, _, _, _, _, buyouta = GetAuctionItemInfo("list", a)
	local _, _, countb, _, _, _, _, _, _, buyoutb = GetAuctionItemInfo("list", b)
	if not buyouta then return false end
	if not buyoutb then return true end
	return buyouta/counta < buyoutb/countb
end

local function iLvlSort(a,b)
	if not a or not b then return false end
	if not b then return true end

	local linka = GetAuctionItemLink("list", a)
	if not linka then return false end
	local _, _, _, iLevela = GetItemInfo(linka)

	local linkb = GetAuctionItemLink("list", b)
	if not linkb then return true end
	local _, _, _, iLevelb = GetItemInfo(linkb)

	if iLevela == iLevelb then return UnitSort(a,b) end
	if ns.sortbyilvl == 1 then
		return (iLevela or 0) < (iLevelb or 0)
	else
		return (iLevela or 0) > (iLevelb or 0)
	end
end

local offset = 0
function ns.Update(self, event)
	local selected = GetSelectedAuctionItem("list")
	AuctionFrame.buyoutPrice = nil
	bidbutt:Disable()

	local numBatchAuctions, totalAuctions = GetNumAuctionItems("list")

	if event == "AUCTION_ITEM_LIST_UPDATE" then
		wipe(ns.sorttable)
		AuctionFrameBrowse.isSearching = nil
		BrowseNoResultsText:SetText(BROWSE_NO_RESULTS)
	end

	BrowseNoResultsText:SetShown(numBatchAuctions == 0)

	if (ns.sortbyunit or ns.sortbyilvl) and not next(ns.sorttable) then
		for i=1,numBatchAuctions do table.insert(ns.sorttable, i) end
		table.sort(ns.sorttable, ns.sortbyunit and UnitSort or iLvlSort)
	end

	for i,row in ipairs(rows) do
		local index = (ns.sortbyunit or ns.sortbyilvl) and ns.sorttable[offset + i] or
		              (offset + i)
		row:SetValue(index)
	end

	local itemsMin = AuctionFrameBrowse.page * NUM_AUCTION_ITEMS_PER_PAGE + 1
	local itemsMax = itemsMin + numBatchAuctions - 1

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

panel:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
panel:SetScript("OnEvent", ns.Update)
panel:SetScript("OnShow", ns.Update)


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
