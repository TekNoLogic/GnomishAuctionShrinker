
local myname, ns = ...


local NUM_ROWS = 14
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
local scrollframe = ns.CreateScrollFrame(panel, columns)

ns.CreateHeader(panel, columns)


local scrollbar, upbutt, downbutt = BrowseScrollFrameScrollBar, BrowseScrollFrameScrollBarScrollUpButton, BrowseScrollFrameScrollBarScrollDownButton
scrollbar.RealSetValue, scrollbar.RealSetMinMaxValues, scrollbar.RealSetValueStep = scrollbar.SetValue, scrollbar.SetMinMaxValues, scrollbar.SetValueStep
scrollbar.SetValue, scrollbar.SetMinMaxValues, scrollbar.SetValueStep = noop, noop, noop

local function OnMouseWheel(self, value) scrollbar:RealSetValue(scrollbar:GetValue() - value*10) end


-----------------------
--      Updater      --
-----------------------

local function UpdateResultText()
	BrowseNoResultsText:SetShown(GetNumAuctionItems("list") == 0)
end


local function OnShow()
	UpdateResultText()

	local num, total = GetNumAuctionItems("list")
	if total > 0 then
		if num-NUM_ROWS <= 0 then
			scrollbar:Disable()
			upbutt:Disable()
			downbutt:Disable()
		else
			scrollbar:Enable()
			scrollbar:RealSetMinMaxValues(0, num-NUM_ROWS)
			scrollbar:RealSetValueStep(1)
		end
	end
end


panel:SetScript("OnShow", OnShow)


ns.RegisterCallback(panel, "AUCTION_ITEM_LIST_UPDATE", function()
	AuctionFrameBrowse.isSearching = nil
	BrowseNoResultsText:SetText(BROWSE_NO_RESULTS)
	UpdateResultText()
end)

ns.RegisterCallback(panel, "AUCTION_QUERY_SENT", function(self, message, all_scan)
	AuctionFrame.buyoutPrice = nil
end)


-------------------------
--      Scrolling      --
-------------------------

panel:SetScript("OnMouseWheel", OnMouseWheel)
panel:EnableMouseWheel(true)
scrollbar:SetScript("OnValueChanged", function(self, value, ...)
	local min, max = self:GetMinMaxValues()
	if value == min then upbutt:Disable() else upbutt:Enable() end
	if value == max then downbutt:Disable() else downbutt:Enable() end
	scrollframe:SetOffset(value)
end)
upbutt:SetScript("OnClick", function() scrollbar:RealSetValue(scrollbar:GetValue() - 10); PlaySound("UChatScrollButton") end)
downbutt:SetScript("OnClick", function() scrollbar:RealSetValue(scrollbar:GetValue() + 10); PlaySound("UChatScrollButton") end)

ns.RegisterCallback(scrollbar, "AUCTION_QUERY_SENT", function(self)
	self:RealSetValue(0)
end)
