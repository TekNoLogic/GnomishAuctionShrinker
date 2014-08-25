
local myname, ns = ...

local BUYOUT_LIMIT = 3000000
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


-- Hide default panels
for i=1,8 do
	local butt = _G["BrowseButton"..i]
	butt:Hide()
	butt.Show = butt.Hide
end


local bidbutt, buybutt = BrowseBidButton, BrowseBuyoutButton

local scrollbar, upbutt, downbutt = BrowseScrollFrameScrollBar, BrowseScrollFrameScrollBarScrollUpButton, BrowseScrollFrameScrollBarScrollDownButton
scrollbar.RealSetValue, scrollbar.RealSetMinMaxValues, scrollbar.RealSetValueStep = scrollbar.SetValue, scrollbar.SetMinMaxValues, scrollbar.SetValueStep
scrollbar.SetValue, scrollbar.SetMinMaxValues, scrollbar.SetValueStep = noop, noop, noop

local nextbutt, prevbutt, counttext = BrowseNextPageButton, BrowsePrevPageButton, BrowseSearchCountText
nextbutt:SetParent(panel)
nextbutt:SetWidth(24) nextbutt:SetHeight(24)
nextbutt:ClearAllPoints()
nextbutt:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", 0, 0)
nextbutt:Show()
nextbutt.RealShow, nextbutt.RealHide, nextbutt.RealEnable, nextbutt.RealDisable = nextbutt.Show, nextbutt.Hide, nextbutt.Enable, nextbutt.Disable
nextbutt.Show, nextbutt.Hide, nextbutt.Enable, nextbutt.Disable = noop, noop, noop, noop
nextbutt:GetRegions():Hide()

prevbutt:SetParent(panel)
prevbutt:SetWidth(24) prevbutt:SetHeight(24)
prevbutt:ClearAllPoints()
prevbutt:SetPoint("RIGHT", nextbutt, "LEFT")
prevbutt:Show()
prevbutt.RealShow, prevbutt.RealHide, prevbutt.RealEnable, prevbutt.RealDisable = prevbutt.Show, prevbutt.Hide, prevbutt.Enable, prevbutt.Disable
prevbutt.Show, prevbutt.Hide, prevbutt.Enable, prevbutt.Disable = noop, noop, noop, noop
prevbutt:GetRegions():Hide()

counttext:SetParent(panel)
counttext:ClearAllPoints()
counttext:SetPoint("RIGHT", prevbutt, "LEFT")
counttext:Show()
counttext.Hide = counttext.Show


local Update, UpdateArrows
local function OnMouseWheel(self, value) scrollbar:RealSetValue(scrollbar:GetValue() - value*10) end
local function RowOnClick(self)
	if IsAltKeyDown() then
		SetSelectedAuctionItem("list", self.index)
		local _, _, _, _, _, _, _, _, _, buyout = GetAuctionItemInfo("list", self.index)
		if buyout > BUYOUT_LIMIT then return HandleModifiedItemClick(self.link) end
		PlaceAuctionBid("list", self.index, buyout)
		CloseAuctionStaticPopups()
	elseif IsModifiedClick() then HandleModifiedItemClick(self.link)
	else
		if GetCVarBool("auctionDisplayOnCharacter") then DressUpItemLink(self.link) end
		SetSelectedAuctionItem("list", self.index)
		CloseAuctionStaticPopups() -- Close any auction related popups
		Update()
	end
end
local function IconOnEnter(self)
	if not self.row.index then return end

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")

	local hasCooldown, speciesID, level, breedQuality, maxHealth, power, speed,
	      name = GameTooltip:SetAuctionItem("list", self.row.index)
	if speciesID and speciesID > 0 then
		BattlePetToolTip_Show(speciesID, level, breedQuality, maxHealth, power,
			                    speed, name)
		return
	end

	GameTooltip_ShowCompareItem()

	if IsModifiedClick("DRESSUP") then ShowInspectCursor() else ResetCursor() end
end

local rows = {}
for i=1,NUM_ROWS do
	local row = CreateFrame("Button", nil, panel)
	row:SetHeight(ROW_HEIGHT)
	row:SetPoint("LEFT")
	row:SetPoint("RIGHT")
	if i == 1 then row:SetPoint("TOP")
	else row:SetPoint("TOP", rows[i-1], "BOTTOM") end
	row:SetScript("OnClick", RowOnClick)
	row:SetScript("OnMouseWheel", OnMouseWheel)
	row:EnableMouseWheel()
	row:Disable()
	rows[i] = row

	row:SetHighlightTexture("Interface\\HelpFrame\\HelpFrameButton-Highlight")
	row:GetHighlightTexture():SetTexCoord(0, 1, 0, 0.578125)

	local icon = CreateFrame("Button", nil, row)
	icon:SetScript("OnEnter", IconOnEnter)
	icon:SetScript("OnLeave", GameTooltip_Hide)
	icon:SetWidth(ROW_HEIGHT-2) icon:SetHeight(ROW_HEIGHT-2)
	icon:SetPoint("LEFT", row, TEXT_GAP, 0)
	icon.row = row
	row.icon = icon

	local name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	name:SetWidth(155) name:SetHeight(ROW_HEIGHT)
	name:SetPoint("LEFT", icon, "RIGHT", TEXT_GAP, 0)
	name:SetJustifyH("LEFT")
	row.name = name

	local min = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	min:SetWidth(23)
	min:SetPoint("LEFT", name, "RIGHT", TEXT_GAP, 0)
	min:SetJustifyH("RIGHT")
	row.min = min

	local ilvl = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	ilvl:SetWidth(33)
	ilvl:SetPoint("LEFT", min, "RIGHT", TEXT_GAP, 0)
	ilvl:SetJustifyH("RIGHT")
	row.ilvl = ilvl

	local owner = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	owner:SetWidth(75) owner:SetHeight(ROW_HEIGHT)
	owner:SetPoint("LEFT", ilvl, "RIGHT", TEXT_GAP, 0)
	owner:SetJustifyH("RIGHT")
	row.owner = owner

	local timeleft = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	timeleft:SetWidth(45)
	timeleft:SetPoint("LEFT", owner, "RIGHT", TEXT_GAP, 0)
	timeleft:SetJustifyH("RIGHT")
	row.timeleft = timeleft

	local bid = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	bid:SetWidth(65)
	bid:SetPoint("LEFT", timeleft, "RIGHT", TEXT_GAP, 0)
	bid:SetJustifyH("RIGHT")
	row.bid = bid

	local buyout = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	buyout:SetWidth(65)
	buyout:SetPoint("LEFT", bid, "RIGHT", TEXT_GAP, 0)
	buyout:SetJustifyH("RIGHT")
	row.buyout = buyout

	local unit = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	unit:SetWidth(65)
	unit:SetPoint("LEFT", buyout, "RIGHT", TEXT_GAP, 0)
	unit:SetJustifyH("RIGHT")
	row.unit = unit

	local qty = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	qty:SetWidth(23)
	qty:SetPoint("LEFT", unit, "RIGHT", TEXT_GAP, 0)
	qty:SetJustifyH("RIGHT")
	row.qty = qty
end


-----------------------
--      Updater      --
-----------------------

local sorttable, sortbyunit, sortbyilvl = {}, false, false
local orig, wipe = QueryAuctionItems, wipe
function QueryAuctionItems(...)
	if select(10, ...) then sortbyunit, sortbyilvl = false, false end
	wipe(sorttable)
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
	if sortbyilvl == 1 then return iLevela < iLevelb
	else return iLevela > iLevelb end
end

local offset, timeframes = 0, {"<30m", "30m-2h", "2-12hr", ">12hr"}
function Update(self, event)
	local selected = GetSelectedAuctionItem("list")
	AuctionFrame.buyoutPrice = nil
	bidbutt:Disable()
	buybutt:Disable()

	local numBatchAuctions, totalAuctions = GetNumAuctionItems("list")

	if event == "AUCTION_ITEM_LIST_UPDATE" then wipe(sorttable) end

	if (sortbyunit or sortbyilvl) and not next(sorttable) then
		for i=1,numBatchAuctions do table.insert(sorttable, i) end
		table.sort(sorttable, sortbyunit and UnitSort or iLvlSort)
	end

	for i,row in pairs(rows) do
		local index = (sortbyunit or sortbyilvl) and sorttable[offset + i] or
		              (offset + i)
		local name, texture, count, quality, canUse, level, levelColHeader, minBid,
    		  minIncrement, buyoutPrice, bidAmount, highBidder, bidderFullName, owner,
              ownerFullName, saleStatus, itemId, hasAllInfo = GetAuctionItemInfo("list", index)
		local displayedBid = bidAmount == 0 and minBid or bidAmount
		local requiredBid = bidAmount == 0 and minBid or bidAmount + minIncrement

		-- Lie about our buyout price
		if requiredBid >= MAXIMUM_BID_PRICE then buyoutPrice = requiredBid end

		if name then
			local color = ITEM_QUALITY_COLORS[quality]
			local link = GetAuctionItemLink("list", index)
			local duration = GetAuctionItemTimeLeft("list", index)
			local _, _, _, iLevel, _, _, _, maxStack = GetItemInfo(link)
			maxStack = maxStack or 1

			row.icon:SetNormalTexture(texture)
			row.name:SetText(name)
			row.name:SetVertexColor(color.r, color.g, color.b)
			row.min:SetText(level ~= 1 and level)
			row.ilvl:SetText(iLevel)
			row.owner:SetText(owner)
			row.timeleft:SetText(timeframes[duration])
			row.bid:SetText(ns.GSC(displayedBid) or "----")
			row.buyout:SetText(buyoutPrice > 0 and ns.GSC(buyoutPrice) or "----")
			row.unit:SetText(buyoutPrice > 0 and maxStack > 1 and ns.GSC(buyoutPrice/count) or "----")
			row.qty:SetText(maxStack > 1 and count)
			row:Enable()

			row.index, row.link = index, link
		else
			row.icon:SetNormalTexture(nil)
			row.name:SetText()
			row.min:SetText()
			row.ilvl:SetText()
			row.owner:SetText()
			row.timeleft:SetText()
			row.bid:SetText()
			row.buyout:SetText()
			row.unit:SetText()
			row.qty:SetText()
			row:Disable()

			row.index, row.link = nil
		end

		if selected and index == selected then
			row:LockHighlight()

			MoneyInputFrame_SetCopper(BrowseBidPrice, requiredBid) -- Set bid
			if not highBidder and owner ~= UnitName("player") and GetMoney() >= MoneyInputFrame_GetCopper(BrowseBidPrice) and MoneyInputFrame_GetCopper(BrowseBidPrice) <= MAXIMUM_BID_PRICE then bidbutt:Enable() end

			if buyoutPrice > 0 and buyoutPrice >= minBid then
				if GetMoney() >= buyoutPrice or (highBidder and GetMoney()+bidAmount >= buyoutPrice) then
					buybutt:Enable()
					AuctionFrame.buyoutPrice = buyoutPrice
				end
			end
		else
			row:UnlockHighlight()
		end
	end

	local itemsMin = AuctionFrameBrowse.page * NUM_AUCTION_ITEMS_PER_PAGE + 1
	local itemsMax = itemsMin + numBatchAuctions - 1

	if totalAuctions == 0 then
		BrowseSearchCountText:Hide()
		prevbutt:RealHide()
		nextbutt:RealHide()
	else
		BrowseSearchCountText:SetFormattedText(NUMBER_OF_RESULTS_TEMPLATE, itemsMin, itemsMax, totalAuctions)
		BrowseSearchCountText:Show()
		prevbutt:RealShow()
		nextbutt:RealShow()
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

	if AuctionFrameBrowse.page == 0 then prevbutt:RealDisable() else prevbutt:RealEnable() end
	if AuctionFrameBrowse.page == (math.ceil(totalAuctions/NUM_AUCTION_ITEMS_PER_PAGE) - 1) then nextbutt:RealDisable() else nextbutt:RealEnable() end

	UpdateArrows()
end

panel:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
panel:SetScript("OnEvent", Update)
panel:SetScript("OnShow", Update)


-------------------------
--      Scrolling      --
-------------------------

panel:SetScript("OnMouseWheel", OnMouseWheel)
panel:EnableMouseWheel()
scrollbar:SetScript("OnValueChanged", function(self, value, ...)
	offset = value
	local min, max = self:GetMinMaxValues()
	if value == min then upbutt:Disable() else upbutt:Enable() end
	if value == max then downbutt:Disable() else downbutt:Enable() end
	Update()
end)
upbutt:SetScript("OnClick", function() scrollbar:RealSetValue(scrollbar:GetValue() - 10); PlaySound("UChatScrollButton") end)
downbutt:SetScript("OnClick", function() scrollbar:RealSetValue(scrollbar:GetValue() + 10); PlaySound("UChatScrollButton") end)


-----------------------
--      Headers      --
-----------------------

local row = rows[1]

local function AnchorSort(butt, left, right, loffset)
	right, loffset = right or left, loffset or (-TEXT_GAP/2 - 1)
	butt:ClearAllPoints()
	butt:SetPoint("TOP", AuctionFrameBrowse, "TOP", 0, -82)
	butt:SetPoint("LEFT", left, "LEFT", loffset, 0)
	butt:SetPoint("RIGHT", right, "RIGHT", TEXT_GAP/2 + 1, 0)
	butt.SetWidth = noop
end

local ilvlsort = ns.MakeSortButton("iLvl")
local buyoutsort = ns.MakeSortButton("Buyout", "buyout")
local unitsort = ns.MakeSortButton("Unit BO")
local qtysort = ns.MakeSortButton("#", "quantity")
ns.MakeSortButton = nil

AnchorSort(BrowseQualitySort, row.icon, row.name, -TEXT_GAP - 2)
AnchorSort(BrowseLevelSort, row.min)
AnchorSort(BrowseHighBidderSort, row.owner)
AnchorSort(BrowseDurationSort, row.timeleft)
AnchorSort(BrowseCurrentBidSort, row.bid)
AnchorSort(ilvlsort, row.ilvl)
AnchorSort(buyoutsort, row.buyout)
AnchorSort(unitsort, row.unit)
AnchorSort(qtysort, row.qty)

BrowseDurationSort:SetText("Time")
BrowseCurrentBidSort:SetText("Bid")
ilvlsort:SetText("iLvl")
buyoutsort:SetText("Buyout")
unitsort:SetText("Unit BO")

local function UpdateArrow(butt)
	local primaryColumn, reversed = GetAuctionSort("list", 1)
	if butt.sortcolumn == primaryColumn then
		butt.arrow:Show()
		butt.arrow:SetTexCoord(0, 0.5625, reversed and 1 or 0, reversed and 0 or 1)
	else butt.arrow:Hide() end
end

function UpdateArrows()
	UpdateArrow(buyoutsort)
	UpdateArrow(qtysort)
end

ilvlsort:SetScript("OnClick", function(self)
	if GetNumAuctionItems("list") > 100 then return end -- Failsafe, don't let sorting be enabled when we have done an all-scan
	sortbyilvl = sortbyilvl == 1 and -1 or sortbyilvl == false and 1 or false
	if sortbyilvl then
		sortbyunit = false
		unitsort.arrow:Hide()
		self.arrow:SetTexCoord(0, 0.5625, sortbyilvl == -1 and 1 or 0, sortbyilvl == -1 and 0 or 1)
		self.arrow:Show()
	else self.arrow:Hide() end
	wipe(sorttable)
	Update()
end)

unitsort:SetScript("OnClick", function(self)
	if GetNumAuctionItems("list") > 100 then return end -- Failsafe, don't let sorting be enabled when we have done an all-scan
	sortbyunit = not sortbyunit
	if sortbyunit then
		sortbyilvl = false
		ilvlsort.arrow:Hide()
		self.arrow:Show()
	else self.arrow:Hide() end
	wipe(sorttable)
	Update()
end)
