
local sorts = {
	buyout     = {"duration", "quantity", "name", "level", "quality", "bid", "buyout"},
	buyout_rev = {     false,       true,  false,    true,     false, false,    false},
	quantity     = {"duration", "buyoutthenbid", "name", "level", "quality", "quantity"},
	quantity_rev = {     false,           false,  false,    true,     false,      false},
}


local function SortAuctions(self)
	local existingSortColumn, existingSortReverse = GetAuctionSort("list", 1) -- change the sort as appropriate
	local oppositeOrder = false
	if existingSortColumn and existingSortColumn == self.sortcolumn then oppositeOrder = not existingSortReverse end

	SortAuctionClearSort("list") -- clear the existing sort.

	local revs = sorts[self.sortcolumn.."_rev"]
	for i,column in ipairs(sorts[self.sortcolumn]) do -- set the columns
		local reverse = revs[i]
		if i == #revs and existingSortColumn and existingSortColumn == self.sortcolumn and (not not existingSortReverse) == reverse then reverse = not reverse end
		SortAuctionSetSort("list", column, reverse)
	end

	AuctionFrameBrowse_Search() -- apply the sort
end


function tek_MakeSortButton(text, sortcolumn)
	local butt = CreateFrame("Button", nil, AuctionFrameBrowse)
	butt:SetHeight(19)

	butt:SetNormalFontObject(GameFontHighlightSmall)
	butt:SetText(text)

	local fs = butt:GetFontString()
	fs:ClearAllPoints()
	fs:SetPoint("LEFT", butt, "LEFT", 8, 0)

	local left = butt:CreateTexture(nil, "BACKGROUND")
	left:SetWidth(5) left:SetHeight(19)
	left:SetPoint("TOPLEFT")
	left:SetTexture("Interface\\FriendsFrame\\WhoFrame-ColumnTabs")
	left:SetTexCoord(0, 0.078125, 0, 0.59375)

	local right = butt:CreateTexture(nil, "BACKGROUND")
	right:SetWidth(4) right:SetHeight(19)
	right:SetPoint("TOPRIGHT")
	right:SetTexture("Interface\\FriendsFrame\\WhoFrame-ColumnTabs")
	right:SetTexCoord(0.90625, 0.96875, 0, 0.59375)

	local middle = butt:CreateTexture(nil, "BACKGROUND")
	middle:SetHeight(19)
	middle:SetPoint("LEFT", left, "RIGHT")
	middle:SetPoint("RIGHT", right, "LEFT")
	middle:SetTexture("Interface\\FriendsFrame\\WhoFrame-ColumnTabs")
	middle:SetTexCoord(0.078125, 0.90625, 0, 0.59375)

	butt:SetNormalTexture("Interface\\Buttons\\UI-SortArrow")
	local normtext = butt:GetNormalTexture()
	normtext:ClearAllPoints()
	normtext:SetPoint("LEFT", fs, "RIGHT", 0, -2)
	normtext:SetWidth(9) normtext:SetHeight(8)
	normtext:SetTexCoord(0, 0.5625, 0, 1)
	normtext:Hide()
	butt.arrow = normtext

	butt:SetHighlightTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight", "ADD")
	local highlight = butt:GetHighlightTexture()
	highlight:ClearAllPoints()
	highlight:SetPoint("LEFT")
	highlight:SetPoint("RIGHT")
	highlight:SetHeight(24)

	butt.sortcolumn = sortcolumn
	if sortcolumn then butt:SetScript("OnClick", SortAuctions) else butt:Disable() end

	return butt
end
